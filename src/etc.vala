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

/*
    This file contains miscellaneous utility functions.
 */


using Gee;


namespace LibVoxel {


	private ArrayList<FileInfo> get_files(string directory, string type) {
		/*
		  Returns an ArrayList of all files of a given type within a
		  directory.  Pass "*" to type if you want it all.
		 */

		var file_list = new ArrayList<FileInfo>();
		
		try {
			var path = File.new_for_path(directory);
			var files = path.enumerate_children(FileAttribute.STANDARD_NAME, 0, null);
			
			FileInfo info = null;
			while ((info = files.next_file(null)) != null) {
				string name = info.get_name();
				string[] parts = name.split(".");
				string ext = parts[parts.length-1].down();
				if (ext == type || type == "*") {
					file_list.add(info);
				}
			}
		} catch (Error e) {
		}

		return file_list;
	}


	private string gen_path (string path, string prefix, string suffix, int num, int digits) {
		/*
		  Generates a file path more or less in the following form:
		  ./some/path/to/file/prefix_0001.suffix
		*/
		string id = num.to_string();
		while (id.length < digits) {
			id = "0" + suffix;
		}
		string result = path + prefix + id + suffix;
		stdout.printf(@"### $result\n");
		return result;
	}
}