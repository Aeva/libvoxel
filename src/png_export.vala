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


	private void save_imgdata (string path, uint8[] imgdata, int width, int height) {
		// write the image file for a given layer to disk
		stdout.printf(@" ! writing $path\n");
		
	}


	private string gen_path (string path, string prefix, string suffix, int num, int digits) {
		// generate the file name for a given layer in the model
		string id = num.to_string();
		while (id.length < digits) {
			id = "0" + suffix;
		}
		return path + prefix + id + suffix;
	}


	public void export_to_pngs (VoxelModel model, string model_dir) {

		stdout.printf("\n\n--> attempting export script\n");
		assert(model.count > 0);
		
		int x = model.min_x;
		int y = model.min_y;
		int z = model.min_z;
		int w = model.width;
		int h = model.height;
		int d = model.depth;

		int line = 0;
		int digits = d.to_string().length;

		int i = 0;
		var img_data = new uint8[w*h*3];
		
		while (x <= w && y <= h && z <= d) {
			// step through the model layer by layer
			

			bool has_data = model.read(x, y, z) > 0;
			for (int s=0; s<3; s+=1){ 
				img_data[i+s] = has_data ? 255 : 0;
			}


			i += 1;
			x += 1;
			if (x > w) {
				x = model.min_x;
				y += 1;
				if (y > h) {
					i = 0;
					y = model.min_y;
					z += 1;

					var out_path = gen_path(model_dir, "layer_", ".png", line, digits);
					save_imgdata(out_path, img_data, w, h);
					line +=1;
				}
			}
		}	
	}
}