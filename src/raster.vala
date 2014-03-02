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


	private void solve_tri_for_y(VoxelModel model, Coord3d a, Coord3d b, Coord3d c) {
		Coord3d common;
		Coord3d[] ends;
		if (a.y == b.y) {
			common = c;
			ends = {a, b};
		}
		else if (a.y == c.y) {
			common = b;
			ends = {a, c};
		}
		else if (b.y == c.y) {
			common = a;
			ends = {b, c};
		}
		else {
			// split & re-call
			Coord3d lower = a;
			Coord3d upper = a;
			Coord3d middle = a;
			Coord3d[] coords = {a, b, c};
			for (int i=1; i<coords.length; i+=1) {
				if (coords[i].y < lower.y) {
					lower = coords[i];
				}
				else if (coords[i].y > upper.y) {
					upper = coords[i];
				}
			}
			for (int i=1; i<coords.length; i+=1) {
				if (coords[i].y != lower.y && coords[i].y != upper.y) {
					middle = coords[i];
				}
			}
			try {
				// z is assumed to be the same for all coordinates
				double split_x = between_2d(middle.y, 
											new Coord2d(lower.x, lower.y), 
											new Coord2d(lower.x, lower.y));
				Coord3d split = new Coord3d(split_x, middle.y, middle.z);
				solve_tri_for_y(model, middle, split, lower);
				solve_tri_for_y(model, middle, split, upper);
			} catch (MathException err) {
				// this should never happen
				stderr.printf("Unreachable block called in function solve_tri_for_z...?\n");
			}
			return;
		}
		double min_y = floor(double.min(ends[0].y, common.y));
		double max_y = floor(double.max(ends[0].y, common.y));
		for (double y=min_y; y<max_y; y+=1) {
			var com = new Coord2d(common.x, common.y);
			var xy1 = new Coord2d(ends[0].x, ends[0].y);
			var xy2 = new Coord2d(ends[1].x, ends[1].y);
			try {
				draw_line(model,
						  new Coord2d(between_2d(y, xy1, com), y),
						  new Coord2d(between_2d(y, xy2, com), y),
						  (int) floor(common.z));
			} catch (MathException err) {
				if (err is MathException.DIVIDE_BY_ZERO) {
					// take both endpoints instead of generating new ones.
					
					draw_line(model, xy1, xy2, (int) floor(common.z));
				}
			}
		}
	}


	private void solve_tri_for_z(VoxelModel model, Coord3d a, Coord3d b, Coord3d c) {
		Coord3d common;
		Coord3d[] ends;
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
			// split & re-call
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
				stdout.printf(@"SPLIT: $middle, $split, $upper, $lower.\n");
				solve_tri_for_z(model, middle, split, lower);
				solve_tri_for_z(model, middle, split, upper);
			} catch (MathException err) {
				// this should never happen
				stderr.printf("Unreachable block called in function solve_tri_for_z...?\n");
			}
			return;
		}
		double min_z = floor(double.min(ends[0].z, common.z));
		double max_z = floor(double.max(ends[0].z, common.z));
		for (double z=min_z; z<max_z; z+=1) {
			var xy1 = ends[0].to_string();
			var xy2 = ends[1].to_string();
			stdout.printf(@"Draw line $xy1 -> $xy2 for z=$z ...?\n");
			try {
				draw_line(model, 
						  between_3d(z, ends[0], common), 
						  between_3d(z, ends[1], common), 
						  (int) z);
			} catch (MathException err) {
				if (err is MathException.DIVIDE_BY_ZERO) {
					// take both endpoints instead of generating new ones.
					draw_line(model,
							  new Coord2d(ends[0].x, ends[0].y),
							  new Coord2d(ends[1].x, ends[1].y),
							  (int) z);
				}
			}
		}
	}


	public void tri_raster(VoxelModel model, Coord3d a, Coord3d b, Coord3d c) {
		/*
		  Render a triangle.
		 */		
		if (a.z == b.z && b.z == c.z) {
			solve_tri_for_y(model, a, b, c);
		}
		else {
			solve_tri_for_z(model, a, b, c);
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