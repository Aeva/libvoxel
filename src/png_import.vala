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


	public VoxelModel import_from_pngs (string model_dir) {
		/*
		  This function creates a voxel model from a folder of PNG
		  files.  The images within are assumed to only contain the
		  colors black and white and will fail loudly if this is not
		  the case.  The images are also assumed to be in order by
		  file name.
		 */

		var model = new VoxelModel();

		var path = File.new_for_path(model_dir);
		var file_iter = path.enumerate_children(FileAttribute.STANDARD_NAME, 0, null);
		var file_info = file_iter.next_file(null);
		while (file_info != null) {
			file_info = file_iter.next_file(null);


			stdout.printf("%s\n", file_info.get_name());
			
		}
		return model;
	}


}