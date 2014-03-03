/*
    This file is part of LibVoxel.

    LibVoxel is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    LibVoxel is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with LibVoxel.  If not, see <http://www.gnu.org/licenses/>.
 */


using Math;
using LibVoxel.Math;


namespace LibVoxel.Raster {


	public void draw_line(VoxelModel model, Coord2d a, Coord2d b, int z) {
		/*
		  Draw a line along a given 2D x/y plane within a voxel model.
		 */
		var low = a.x < b.x ? a : b;
		var high = a.x < b.x ? b : a;

		double x1 = floor(low.x);
	    double x2 = floor(high.x);
		
		for (var x = x1; x<=x2; x+=1) {
			double y = low.y;
			if (x2 != x1) {
				var i = (x-x1) / (x2-x1);
				y = floor(mix(low.y, high.y, i));
			}
			model.add((int) x, (int) y, z);
				
		}
	}


	private delegate void AxialMapFunc (int x, int y, int z);
	// AxialMapFunction is responsible for calling m.add(x,y,z) for some
	// desired coordinate mapping.


	private void render_line(AxialMapFunc add, Coord2d a, Coord2d b, int z) {
		/*
		  Draw a line along a given 2D x/y plane within a voxel model.
		 */
		var low = a.x < b.x ? a : b;
		var high = a.x < b.x ? b : a;

		double x1 = floor(low.x);
	    double x2 = ceil(high.x);
		
		for (var x = x1; x<=x2; x+=1) {
			double y = low.y;
			if (x2 != x1) {
				var i = (x-x1) / (x2-x1);
				y = round(mix(low.y, high.y, i));
			}
			add((int) x, (int) y, z);
		}
	}


	private void rasterize_for_plane(AxialMapFunc add, Coord3d a, Coord3d b, Coord3d c) {
		/*
		  Called by 'rasterize'.  This function rasterizes a triangle
		  defined by points 'a', 'b', and 'c' from the perspective of
		  the z-plane.  The add delegate is used to add the resulting
		  voxels into a voxel model.

		  Some trickery is used by the 'rasterize' function to make
		  this work for the x and y planes as well.
		 */
		Coord3d common;
		Coord3d[] ends;
		// determine which edge is horizontal
		if (a.z == b.z) {
			common = c;
			ends = {a, b};
		}
		else if (a.z == c.z) {
			common = b;
			ends = {a, c};
		}
		else if (b.z == c.z) {
			common = a;
			ends = {b, c};
		}
		else {
			// no edge is horizontal - split the triangle into two
			// triangles and recurse.
			Coord3d lower = a;
			Coord3d upper = a;
			Coord3d middle = a;
			Coord3d[] coords = {a, b, c};
			for (int i=1; i<coords.length; i+=1) {
				if (coords[i].z < lower.z) {
					lower = coords[i];
				}
				else if (coords[i].z > upper.z) {
					upper = coords[i];
				}
			}
			for (int i=1; i<coords.length; i+=1) {
				if (coords[i].z != lower.z && coords[i].z != upper.z) {
					middle = coords[i];
				}
			}
			try {
				Coord2d split_xy = between_3d(middle.z, lower, upper);
				Coord3d split = new Coord3d(split_xy.x, split_xy.y, middle.z);
				rasterize_for_plane(add, middle, split, lower);
				rasterize_for_plane(add, middle, split, upper);
			} catch (MathException err) {
				// this should never happen...?
				stderr.printf("Unimplemented edge case in rasterize_for_plane:\n");
				stderr.printf(@"DATA: lower=$lower middle=$middle upper=$upper\n");
			}
			return;
		}
		double min_z = double.min(ends[0].z, common.z);
		double max_z = double.max(ends[0].z, common.z);
		for (double z=min_z; z<max_z; z+=1) {
			try {
				render_line(add, 
						  between_3d(z, ends[0], common), 
						  between_3d(z, ends[1], common), 
						  (int) z);
			} catch (MathException err) {
				if (err is MathException.DIVIDE_BY_ZERO) {
					// take both endpoints instead of generating new ones.
					render_line(add,
								new Coord2d(ends[0].x, ends[0].y),
								new Coord2d(ends[1].x, ends[1].y),
								(int) z);
				}
			}
		}
	}


	public void rasterize(VoxelModel model, Coord3d a, Coord3d b, Coord3d c) {
		/*
		  Rasterize a triangle defined by points 'a', 'b', and 'c'
		  into VoxelModel 'm'.
		 */

		// Temporary voxel model used like a set to avoid adding redundant data.
		//var tmp_model = new VoxelModel();
		var tmp_model = model; // FIXME: HACK

		bool render_for_x = true;
		bool render_for_y = true;
		bool render_for_z = true;

		// Check to see if all three coordinates fall on the same
		// plane.  If so, only render from one perspective:
		if (a.x == b.x && b.x == c.x) {
			render_for_x = false; // <-- for sure
			render_for_y = false; // <-- a guess
		}
		if (a.y == b.y && b.y == c.y) {
			render_for_y = false; // <-- for sure
			render_for_z = false; // <-- a guess
		}
		if (a.z == b.z && b.z == c.z) {
			render_for_x = false; // <-- a guess
			render_for_z = false; // <-- for sure
		}

		// Edge case: all three points are the same:
		if (!render_for_x && !render_for_y && !render_for_z) {
			model.add((int) a.x, (int) a.y, (int) a.z);
			return;
		}
		
		/*
		  To avoid repeating myself, the same rendering function is
		  used for all three views; thus for two of the views, the
		  points need to be rotated 90 degrees on some axis, and the
		  "model.add" function is replaced by a delegate that rotates
		  them back.  "Rotation" is done by mixing up the coordinate
		  order.
		 */
		if (render_for_x) {
			var a_shift = new Coord3d(a.z, a.y, a.x);
			var b_shift = new Coord3d(b.z, b.y, b.x);
			var c_shift = new Coord3d(c.z, c.y, c.x);
			rasterize_for_plane((x,y,z) => {tmp_model.add(z, y, x);},
								a_shift, b_shift, c_shift);
		}
		if (render_for_y) {
			var a_shift = new Coord3d(a.x, a.z, a.y);
			var b_shift = new Coord3d(b.x, b.z, b.y);
			var c_shift = new Coord3d(c.x, c.z, c.y);
			rasterize_for_plane((x,y,z) => {tmp_model.add(x, z, y);},
								a_shift, b_shift, c_shift);		
		}
		if (render_for_z) {
			rasterize_for_plane((x,y,z) => {tmp_model.add(x, y, z);}, a, b, c);
		}
	}


	public void quad_raster(VoxelModel model, Quad<Coord2d> quad, int z) {
		/*
		  Fill in a quad on a given 2D x/y plane within a voxel model.
		*/
		Coord2d[] points = {quad.a, quad.b, quad.c, quad.d};
		Coord2d[,] pairings = {
			{ quad.a, quad.b },
			{ quad.b, quad.c },
			{ quad.c, quad.d },
			{ quad.d, quad.a },
			};

		double y_min = quad.a.y;
		double y_max = quad.a.y;
		for (int i=1; i<points.length; i+=1) {
			// yes, starting at i=1 is intentional
			Coord2d point = points[i];
			if (point.y < y_min) {
				y_min = point.y;
			}
			if (point.y > y_max) {
				y_max = point.y;
			}
		}

		for (double y=y_min; y<= y_max; y+=1) {
			Coord2d? first = null;
			Coord2d? second = null;
			
			for (int i=0; i<pairings.length[0]; i+=1) {
				Coord2d a = pairings[i,0];
				Coord2d b = pairings[i,1];
				try {
					var x = between_2d(y, a, b); // x intersection
					if (first == null) {
						first = new Coord2d(floor(x), y);
					}
					else if (second == null) {
						second = new Coord2d(floor(x), y);
						break;
					}
				} catch (MathException Err) {
					if (Err is MathException.DIVIDE_BY_ZERO) {
						// take both endpoints instead of generating new ones.
						first = a;
						second = b;
						break;
					}
					else {
						// these are not the coords you're looking for.
						continue;
					}
				}
			}
			if (first != null && second != null) {
				draw_line(model, first, second, z);
			}
		}
	}

	
	public void frustum_raster (VoxelModel model, Quad<Coord3d> lhs, Quad<Coord3d> rhs) {
		/*
		  Rasterizes a quadrilateral frustum defined by its front and
		  back planes.  Not specific to frustums despite name and
		  intention, should work with any convex hexahedron.
		 */

		double min_z = lhs.a.z;
		double max_z = lhs.a.z;
		
		Coord3d[] point_set = {
			lhs.a, lhs.b, lhs.c, lhs.d,
			rhs.a, rhs.b, rhs.c, rhs.d,
		};
		for (int i=1; i<point_set.length; i +=1) {
			// yes, starting at i=1 is intentional
			var point = point_set[i];
			if (point.z < min_z) {
				min_z = point.z;
			}
			if (point.z > min_z) {
				max_z = point.z;
			}			
		}

		Coord3d[,] pairings = {
			{ lhs.a, lhs.b },
			{ lhs.b, lhs.c },
			{ lhs.c, lhs.d },
			{ lhs.d, lhs.a },

			{ lhs.a, rhs.a },
			{ lhs.b, rhs.b },
			{ lhs.c, rhs.c },
			{ lhs.d, rhs.d },

			{ rhs.a, rhs.b },
			{ rhs.b, rhs.c },
			{ rhs.c, rhs.d },
			{ rhs.d, rhs.a },
		};

		Coord2d[] found = {};
		for (double z = min_z; z <= max_z; z+=1) {
			for (int i=0; i<pairings.length[0]; i+=1) {
				var a = pairings[i,0];
				var b = pairings[i,1];
				try {
					Coord2d point = between_3d(z, a, b);
					found += point;
					continue;
				} catch (MathException Err) {
					if (Err is MathException.DIVIDE_BY_ZERO) {
						// take both endpoints instead of generating new ones.
						found += new Coord2d(a.x, a.y);
						found += new Coord2d(b.x, b.y);						
					}
					else {
						// these are not the coords you're looking for.
						continue;						
					}
				}
			}
			if (found.length > 4) {
				// trim out the non-unique coordinates
				Coord2d[] unique = {};
				foreach (Coord2d pt in found) {
					bool duplicate = false;
					foreach (Coord2d check in unique) {
						if (check.x == pt.x && check.y == pt.y) {
							duplicate = true;
							break;
						}
					}
					if (!duplicate) {
						unique += pt;
					}
				}
				found = unique;
			}			
			if (found.length == 1) {
				draw_line(model, found[0], found[0], (int) z);
			}
			else if (found.length == 2) {
				draw_line(model, found[0], found[1], (int) z);
			}
			else if (found.length == 3) {
				// convert triangle to quad.
				var quad = new Quad<Coord2d>(found[0], found[1], found[2], found[2]);
				quad_raster(model, quad, (int) z);
			}
			else if (found.length == 4) {
				var quad = new Quad<Coord2d>(found[0], found[1], found[2], found[3]);
				quad_raster(model, quad, (int) z);
			}
			found = {};
		}
	}
}