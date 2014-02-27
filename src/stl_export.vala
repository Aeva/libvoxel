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


namespace LibVoxel {


	public void export_stl(VertexDump vertex_data, string export_path) {

		var file = File.new_for_path(export_path);
		if (file.query_exists()) {
			stderr.printf("File '%s' already exist.\n", file.get_path());
			return;
		}
		try {
			var open = file.create(FileCreateFlags.REPLACE_DESTINATION);
			var stream = new DataOutputStream(open);
			stream.put_string("solid libvoxel export\n");

			foreach (var triangle in vertex_data.triangles) {
				// FIXME: normal data should be calculated somewhere
				Coord3d[] verts = {triangle.a, triangle.b, triangle.c};
				string block = "facet normal 0 0 0\n";
				block += "    outer loop\n";
				foreach (var pt in verts) {
					var x = pt.x;
					var y = pt.y;
					var z = pt.z;
					block += @"        vertex $x $y $z\n";
				}
				block += "    endloop\n";
				block += "endfacet\n";
				stream.put_string(block);
			}
			stream.close();
		} catch (Error err) {			
			stdout.printf(err.message + "\n");
		}
    }
}