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

		double low = -10;
		double high = 10;

		var start = new Coord2d(low, low);
		var end = new Coord2d(high, high);
		draw_line(model, start, end, 0);

		stdout.printf("--> Testing line draw function.\n");
		string line;
		for (int y=(int)low; y<high; y+=1) {
			line = ">> ";
			for (int x=(int)low; x<high; x+=1) {
				int expected = x==y ? 1 : 0;
				assert(model.read(x, y, 0) == expected);
				line += x==y ? " #" : " _";
			}
			stdout.printf(line+"\n");
		}
		
		var export = export_base + "line_raster/"; 
		stdout.printf(@"--> Line rasterization test to $export\n");
		export_to_pngs(model, export);
	}


}
