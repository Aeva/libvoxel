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

namespace LibVoxel.Math {


	public errordomain MathException {
		OUT_OF_BOUNDS,
		DIVIDE_BY_ZERO,
	}



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

		public string to_string() {
			return @"($x, $y, $z)";
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

		public string to_string() {
			return @"($x, $y)";
		}
	}


	public class Triangle<coord> : Object {
		public coord a;
		public coord b;
		public coord c;
		
		public Triangle(coord a, coord b, coord c) {
			this.a = a;
			this.b = b;
			this.c = c;
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


	public class Mat4: Object {
		public double[,] data = {
			{1, 0, 0, 0}, 
			{0, 1, 0, 0}, 
			{0, 0, 1, 0},
			{0, 0, 0, 1},
		};

		public Mat4.x_rotate(double degrees) {
			var theta = radians(degrees);
			var ct = cos(theta);
			var st = sin(theta);
			var nct = -1*ct;
			var nst = -1*st;
			this.data = {
				{1,  0,   0, 0},
				{0, ct, nst, 0},
				{0, st, nct, 0},
				{0,  0,   0, 1},
			};
		}

		public Mat4.y_rotate(double degrees) {
			var theta = radians(degrees);
			var ct = cos(theta);
			var st = sin(theta);
			var nst = -1*st;
			this.data = {
				{ ct,  0, st, 0},
				{  0,  1,  0, 0},
				{nst,  0, ct, 0},
				{  0,  0,  0, 1},
			};
		}

		public Mat4.z_rotate(double degrees) {
			var theta = radians(degrees);
			var ct = cos(theta);
			var st = sin(theta);
			var nst = -1*st;
 			this.data = {
				{ct, nst, 0, 0},
				{st,  ct, 0, 0},
				{ 0,   0, 1, 0},
				{ 0,   0, 0, 1},
			};
		}

		public Mat4.offset(double x, double y, double z) {
			this.data = {
				{1, 0, 0, x},
				{0, 1, 0, y},
				{0, 0, 1, z},
				{0, 0, 0, 1},
			};
		}
		
		public Coord3d multiply(Coord3d coord) {
			/*
			  Apply a matrix to a coordinate.
			*/
			double[] vector = {coord.x, coord.y, coord.z, 1};
			double[] result = {0,0,0,1};
			for (int y = 0; y<4; y+=1) {
				double cache = 0;
				for (int x = 0; x<4; x+=1) {
					cache += this.data[y,x] * vector[x];
				}
				result[y] = cache;
			}
			return new Coord3d(result[0], result[1], result[2]);
		}
	}


	public double radians ( double degrees ) {
		// Convert from degrees to radians.
		if (degrees == 0) {
			return 0;
		}
		return PI / (180 / degrees);
	}


	public Coord3d clamp(Coord3d coord) {
		return new Coord3d(
			floor(coord.x*10000)/10000,
			floor(coord.y*10000)/10000,
			floor(coord.z*10000)/10000);
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


	public double between_2d(double y, Coord2d a, Coord2d b) throws MathException {
		/* 
		  Determines if value 'y' is within a line segment defined by
		  points 'a' and 'b'.  Returns the value of 'x' if y falls
		  within the line segment.  Throws MathException.OUT_OF_BOUNDS
		  or MathException.DIVIDE_BY_ZERO for the two special cases
		  that might arrise with this function.
		*/
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
			if (high.y == low.y) {
				throw new MathException.DIVIDE_BY_ZERO(
					"Both coordinates have the same Y value.");
			}
			var i = (y-low.y) / (high.y-low.y);
			return mix_2d(low, high, i).x;
		}
		else {
			throw new MathException.OUT_OF_BOUNDS(
				"Given value of Y is outside of the line segment.");
		}
	}


	public Coord2d between_3d(double z, Coord3d a, Coord3d b) throws MathException {
		/*
		  Determines if value 'z' is within a line segment defined by
		  points 'a' and 'b'.  Returns a 2D coordinate for the given
		  value of z.  Throws MathException.OUT_OF_BOUNDS
		  or MathException.DIVIDE_BY_ZERO for the two special cases
		  that might arrise with this function.
		*/
		var low = a.z < b.z ? a : b;
		var high = a.z < b.z ? b : a;

		if (z >= low.z && z <= high.z ) {
			if (high.z == low.z) {
				throw new MathException.DIVIDE_BY_ZERO(
					"Both coordinates have the same Z value.");
			}
			var i = (z-low.z) / (high.z-low.z);
			var between = mix_3d(low, high, i);
			var x = between.x;
			var y = between.y;
			return new Coord2d(x, y);
		}
		else {
			throw new MathException.OUT_OF_BOUNDS(
				"Given value of Z is outside of the line segment.");
		}
	}
}