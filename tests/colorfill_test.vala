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


namespace LibVoxel.Tests {

	public void colorfill_tests(string data_path, string base_path) {
		
		string import_path = data_path + "fill_test/";
		string cast_export = base_path + "cast_test.stl";
		string cast_png_export = base_path + "cast_test/";
		string ref_export = base_path + "precast_reference.stl";

		var model = import_from_pngs(import_path);

		stdout.printf("Color fill test! woo!\n");
		var result = cast(model);

		for(int z=result.min_z; z<=result.max_z; z+=1) {
			stdout.printf(@"Plot for z=$z in result model.\n");
			plot(result, z);
		}

		stdout.printf(@"saved reference to $ref_export\n");
		export_stl(model, ref_export, 1.0);
		stdout.printf(@"saved cast to $cast_export\n");
		export_stl(result, cast_export, 1.0);
		stdout.printf(@"saved cast to $cast_png_export\n");
		export_to_pngs(result, cast_png_export);
	}
}