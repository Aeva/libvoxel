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
using LibVoxel.Raster;


namespace LibVoxel.Tests {

	public void raster_tests(string data_path, string export_base) {
		var model = new VoxelModel();
		var start = new Coord2d(-2, -2);
		var end = new Coord2d(2, 2);
		draw_line(model, start, end, 0);

		assert(model.read(-2, -2, 0) == 1);
		assert(model.read(-1, -1, 0) == 1);
		assert(model.read(0, 0, 0) == 1);
		assert(model.read(1, 1, 0) == 1);
		assert(model.read(2, 2, 0) == 1);

		var export = export_base + "line_raster/"; 
		stdout.printf("--> Line rasterization test to $export\n");
		export_to_pngs(model, export);
	}


}
