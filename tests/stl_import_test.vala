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


	public void test_stl_import_tests(string data_path, string base_path) {
		string import_path = data_path + "suzanne_ascii.stl";
		string export_path = base_path + "suzanne_export.stl";

		stdout.printf("--> Testing .STL importer.\n");

		stdout.printf(@" - importing test data from $data_path.\n");
		var model = import_from_stl(import_path, 1);

		stdout.printf(@" - theoretically exporting to $export_path.\n");
		export_stl(model, export_path);
	}
}