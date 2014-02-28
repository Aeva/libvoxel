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
}