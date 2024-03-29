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


	public void test_stl_export_tests(string data_path, string base_path) {
		string import_path = data_path + "tiny_cube/";
		string export_path = base_path + "tiny_cube.stl";

		stdout.printf("--> Testing .STL exporter.\n");

		stdout.printf(@" - importing test data from $data_path.\n");
		var model = import_from_pngs(import_path);
		stdout.printf(@" - theoretically exporting to $export_path.\n");
		export_stl(model, export_path, 1.0);
	}
}