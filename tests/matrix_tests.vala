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


using LibVoxel.Math;

namespace LibVoxel.Tests {

	public void matrix_tests() {
		stdout.printf("--> Matrix multiplication tests:\n");

		Coord3d coord;
		Mat4 matrix;
		Coord3d result;
		double theta;

		coord = new Coord3d(0, 1, 0);
		theta = 90;
		matrix = new Mat4.x_rotate(theta);
		result = clamp(matrix.multiply(coord));
		stdout.printf(coord.to_string() + @" * xrotate($theta) = " + result.to_string() + "\n");

		coord = new Coord3d(1, 0, 0);
		theta = 90;
		matrix = new Mat4.y_rotate(theta);
		result = clamp(matrix.multiply(coord));
		stdout.printf(coord.to_string() + @" * yrotate($theta) = " + result.to_string() + "\n");

		coord = new Coord3d(1, 0, 0);
		theta = 90;
		matrix = new Mat4.z_rotate(theta);
		result = clamp(matrix.multiply(coord));
		stdout.printf(coord.to_string() + @" * zrotate($theta) = " + result.to_string() + "\n");

		coord = new Coord3d(1, 0, 0);
		matrix = new Mat4.offset(10, 10, 10);
		result = clamp(matrix.multiply(coord));
		stdout.printf(coord.to_string() + @" * offset(10, 10, 10) = " + result.to_string() + "\n");

	}

}