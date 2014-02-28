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

	public class BitMask : Object {
		public bool[,] data;
		public int width;
		public int height;
		
		public BitMask(int width, int height) {
			this.data = new bool[width, height];
			this.width = width;
			this.height = height;
			for (int y=0; y<height; y+=1) {
				for (int x=0; x<width; x+=1) {
					this.data[x,y] = false;
				}
			}
		}

		public BitMask.from_img(string path) throws Error {
			var pixbuf = new Pixbuf.from_file(path);
			var pxdata = pixbuf.get_pixels_with_length();
			int channels = pixbuf.get_n_channels();
			int width = pixbuf.get_width();
			int height = pixbuf.get_height();

			this.data = new bool[width, height];
			this.width = width;
			this.height = height;

			int x = 0;
			int y = 0;
			int i = 0;
			while (x < width && y < height) {
				var sample = 0;
				for (int s=i; s<i+channels; s+=1) {
					sample += pxdata[s];
				}
				sample = sample/channels;
				this.data[x,y] = sample > 128;
				i += channels;
				x += 1;
				if (x >= width) {
					x = 0;
					y += 1;
				}
			}
		}

		public new bool get(int x, int y) {
			return this.data[x, y];
		}

		public new void set(int x, int y, bool value) {
			this.data[x, y] = value;
		}
	}


	public VoxelModel import_from_pngs (string model_dir) {
		/*
		  This function creates a voxel model from a folder of PNG
		  files.  The images within are assumed to only contain the
		  colors black and white.  If this is not the case, the color
		  will be clamped.  The images are also assumed to be in order
		  by file name.
		 */
		var files = get_files(model_dir, "png");
		var model = new VoxelModel();
		int z=0;
		var paths = new List<string>();
		foreach (var file in files) {
			string path = file.get_name();
			paths.append(path);
		}
		paths.sort(strcmp);
		foreach (var file_name in paths) {
			var path = model_dir + file_name;
			try {
				var mask = new BitMask.from_img(path);
				
				for (int y=0; y<mask.height; y+=1) {
					for (int x=0; x<mask.width; x+=1) {
						if (mask[x,y]) {
							model.add(x, y, z);
						}
					}
				}
				z+=1;
			} catch (Error e) {
			}
		}
		return model;
	}
}