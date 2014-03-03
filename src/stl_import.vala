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


namespace LibVoxel {


	public errordomain STLImportError {
		ASCII_PARSE_ERROR,
		BINARY_PARSE_ERROR,
	}


	private VoxelModel import_from_binary_stl (DataInputStream data, double scale) {
		/*
		  Rasterizes a model from a stl file (binary variant).
		 */
		var model = new VoxelModel();
		return model;
	}


	private VoxelModel import_from_ascii_stl (DataInputStream data, double scale) {
		/*
		  Rasterizes a model from a stl file (ascii variant).
		 */
		string header = data.read_line();
		Coord3d[] vertices = {};

		while (true) {
			string? line = data.read_line();
			if (line == null) {
				break;
			}
			else if (line.chomp().has_prefix("vertex")) {
				// We only care about the vertex data, and can safely
				// ignore all of the structural chaff in the format.
				string chunk = line[line.index_of("vertex")+7:line.length].chomp();
				string[] params = chunk.split(" ");
				var a = double.parse(params[0]) * scale;
				var b = double.parse(params[1]) * scale;
				var c = double.parse(params[2]) * scale;
				vertices += new Coord3d(a, b, c);
			}
		}
		
		assert(vertices.length % 3 == 0);
		var model = new VoxelModel();
		for (int i=0; i<vertices.length; i+=3) {
			var a = vertices[i+0];
			var b = vertices[i+1];
			var c = vertices[i+2];
			rasterize(model, a, b, c);
		};
		return model;
	}


	public VoxelModel import_from_stl (string model_path, double resolution) {
		/*
		  Rasterizes a model from a stl file (whichever variant).
		 */

		// FIXME: do something with the resolution variable

		var file = File.new_for_path(model_path);
		var data = new DataInputStream(file.read());

		var buffer = new uint8[5];
		data.read(buffer);
		string peek = (string) buffer;
		data.seek(0, SeekType.SET);

		double scale = 5.0; // arbitrary scale factor

		if (peek == "solid") {
			// file is probably ascii formatted
			return import_from_ascii_stl(data, scale);
		}
		else {
			// file is probably binary formatted
			return import_from_binary_stl(data, scale);
		}
	}
}