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


using Gdk;


namespace LibVoxel {


	private Pixbuf make_buffer (uint8[] imgdata, int width, int height) {
		/*
		  Create and return a pixbuf object from provided image data.
		*/


		var colorspace = Colorspace.RGB;
		int channels = 3;
		int row_stride = width * channels;

		// FIXME: memory leak? (see "null" param)
		var pixbuf = new Pixbuf.from_data(
		    imgdata, colorspace, false, 8, width, height, row_stride, null);

		return pixbuf;
	}


	private void paint_layer (VoxelModel model, int z, string model_dir) {
		/*
		  Create the image data for a given layer.
		 */

		int x = model.min_x;
		int y = model.min_y;
		int channels = 3;
		uint8[] img_data = {};
		
		while (x <= model.max_x && y <= model.max_y) {
			bool has_data = model.read(x, y, z) > 0;
			for (int s=0; s<channels; s+=1){ 
				img_data += has_data ? 255 : 0;
			}
			x += 1;
			if (x > model.max_x) {
				x = model.min_x;
				y += 1;
			}
		}
		
		var buffer = make_buffer(img_data, model.width, model.height);

		int line = model.max_z + z;
		int digits = model.depth.to_string().length;
		string out_path = gen_path(model_dir, "layer_", ".png", line, digits);

		try {
			buffer.savev(out_path, "png", {null}, {null});
		} catch (Error e) {
			stdout.printf(e.message + "\n");
		}
		return;
	}


	public void export_to_pngs (VoxelModel model, string model_dir) {
		/*
		  Take a VoxelModel and dump out it's contents as a folder of
		  png files somewhere.
		 */

		assert(model.count > 0);

		var img_dir = File.new_for_path(model_dir);
		bool abort = false;
		try {
			img_dir.make_directory(null);
		} catch (Error e) {
			abort = true;
			stdout.printf(e.message + "\n");
		}
		if (!abort) {
			for (int z = model.min_z; z< model.depth; z+=1) {
				paint_layer(model, z, model_dir);
			}
		}
	}
}