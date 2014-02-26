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
		 */
		var low = a.x < b.x ? a : b;
		var high = a.x < b.x ? b : a;

		double x1 = floor(low.x);
	    double x2 = floor(high.x);
		
		for (var x = x1; x<=x2; x+=1) {
			var i = (x-x1) / (x2-x1);
			var y = floor(mix(x1, x2, i));

			int _x = (int) x;
			int _y = (int) y;
			stdout.printf(@"Drawing at $_x $_y\n");


			model.add((int) x, (int) y, z);
		}
	}
}