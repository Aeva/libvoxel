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


namespace LibVoxel {


	public void test_png_import_export(string test_data_path) {
		string import_path = test_data_path + "tiny_cube/";
		string export_path = test_data_path + "../../debug/tiny_cube_export/";

		stdout.printf(@"--> Attempting to import model from: $import_path\n");
		var model = import_from_pngs(import_path);

		stdout.printf(@"--> Attempting to save imported model to: $export_path\n");
		export_to_pngs(model, export_path);
	}
}