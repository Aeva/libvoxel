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


namespace LibVoxel.Math {


	public class Coord3d : Object {
		/*
		  X, Y, and Z are expressed as doubles.
		 */
		public double x;
		public double y;
		public double z;

		public Coord3d(double x, double y, double z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}


	public class Coord2d : Object {
		/*
		  X, and Y are expressed as doubles.
		*/
		public double x;
		public double y;

		public Coord2d(double x, double y) {
			this.x = x;
			this.y = y;
		}
	}


	public class Quad<coord> : Object {
		public coord a;
		public coord b;
		public coord c;
		public coord d;
		
		public Quad(coord a, coord b, coord c, coord d) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
		}
	}


	public double mix(double a, double b, double i) {
		/*
		  Returns the linear blend between a and b.  'i' is assumed to
		  be >= 0 and <= 1.0.
		*/
		return a + (b - a) * i;
	}


	public Coord2d mix_2d(Coord2d a, Coord2d b, double i) {
		/*
		  Returns the linear blend between two coordinates.  See
		  comment for the "mix" function.
		*/
		var x = mix(a.x, b.x, i);
		var y = mix(a.y, b.y, i);
		return new Coord2d(x, y);
	}

	
	public Coord3d mix_3d(Coord3d a, Coord3d b, double i) {
		/*
		  Returns the linear blend between two coordinates.  See
		  comment for the "mix" function.
		*/
		var x = mix(a.x, b.x, i);
		var y = mix(a.y, b.y, i);
		var z = mix(a.z, b.z, i);
		return new Coord3d(x, y, z);
	}


	public double? between_2d(double y, Coord2d a, Coord2d b) {
		/* 
		  Determines if value 'y' is within a line segment defined by
		  points 'a' and 'b'.  Returns null if it falls outside of the
		  endpoints, otherwise returns the value of 'x' if it does
		  fall within the line segment.
		*/
		double? result = null;
		Coord2d low;
		Coord2d high;
		if (a.y < b.y) {
			low = a;
			high = b;
		}
		else {
			high = a;
			low = b;
		}

		if (y >= low.y && y <= high.y ) {
			var i = (y-low.y) / (high.y-low.y);
			result = mix_2d(a, b, i).x;
		}
		return result;
	}


	public Coord2d? between_3d(double z, Coord3d a, Coord3d b) {
		/*
		  Determines if value 'z' is within a line segment defined by
		  points 'a' and 'b'.  Returns null if it falls outside of the
		  endpoints, otherwise returns a 2D coordinate that
		  cooresponds for the value of 'z' in that line segment.
		*/

		Coord2d? result = null;
		var low = a.z < b.z ? a : b;
		var high = a.z < b.z ? b : a;

		if (z >= low.z && z <= high.z ) {
			var i = (z-low.z) / (high.z-low.z);
			var between = mix_3d(low, high, i);
			var x = between.x;
			var y = between.y;
			result = new Coord2d(x, y);
		}
		return result;
	}
}