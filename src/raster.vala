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
// FIXME: pairings are commented out to exclude redundancy in the edge
// case where in several are on the same z plane.  Instead, we should
// probably check for redundancy instead.  EG, unsure if the commented
// out pairings are actually needed or not.
			{ lhs.a, lhs.b },
//			{ lhs.b, lhs.c },
			{ lhs.c, lhs.d },
//			{ lhs.d, lhs.a },

			{ lhs.a, rhs.a },
			{ lhs.b, rhs.b },
			{ lhs.c, rhs.c },
			{ lhs.d, rhs.d },

			{ rhs.a, rhs.b },
//			{ rhs.b, rhs.c },
			{ rhs.c, rhs.d },
//			{ rhs.d, rhs.a },
		};

		Coord2d[] found = {};
		for (double z = min_z; z <= max_z; z+=1) {
			for (int i=0; i<pairings.length[0] && found.length<4; i+=1) {
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
			if (found.length == 4) {
				var quad = new Quad<Coord2d>(found[0], found[1], found[2], found[3]);
				quad_raster(model, quad, (int) z);
			}
			found = {};
		}
	}
}