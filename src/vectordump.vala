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


namespace LibVoxel.Math {


	public class VertexDump : Object {
		/*
		  VertexDump objects are used for converting Voxel Models into
		  conventional 3D models.
		  
		  This class is intended for organizing data either to export
		  to conventional 3D model formats (eg .stl), or for the
		  purpose of building vertex buffer objects for visualization.
		 */

		// FIXME: maybe this should be a linked list?
		private Triangle<Coord3d>[] __triangles;
		public Triangle<Coord3d>[] triangles {
			get {
				return this.__triangles;
			}
		}
		
		public VertexDump(VoxelModel model) {
			/*
			  FIXME: this should implement the marching cubes
			  algorithm or similar.
			*/
			/*
			  FIXME: this could be sped up quite a bit with threading.
			 */

			for (int z=model.min_z; z<=model.max_z; z+=1) {
				for (int y=model.min_y; y<=model.max_y; y+=1) {
					for (int x=model.min_x; x<=model.max_x; x+=1) {
						// FIXME: account for diagonals AKA this is
						// not quite the marching cubes algorithm :3
						var vox = model.read(x, y, z);
						if (vox > 0) {
							var below = model.read(x, y, z-1);
							var above = model.read(x, y, z+1);
							var north = model.read(x, y+1, z);
							var south = model.read(x, y-1, z);
							var east = model.read(x+1, y, z);
							var west = model.read(x-1, y, z);

							if (below == 0) {
								this.add_quad(
									new Coord3d(x,   y+1, z),
									new Coord3d(x+1, y+1, z),
									new Coord3d(x+1, y, z),
									new Coord3d(x,   y, z));
							}
							if (above == 0) {
								this.add_quad(
									new Coord3d(x,   y+1, z+1),
									new Coord3d(x+1, y+1, z+1),
									new Coord3d(x+1, y, z+1),
									new Coord3d(x,   y, z+1));
							}
							if (north == 0) {
								this.add_quad(
									new Coord3d(x,   y+1, z+1),
									new Coord3d(x+1, y+1, z+1),
									new Coord3d(x+1, y+1, z),
									new Coord3d(x,   y+1, z));
							}
							if (south == 0) {
								this.add_quad(
									new Coord3d(x,   y, z+1),
									new Coord3d(x+1, y, z+1),
									new Coord3d(x+1, y, z),
									new Coord3d(x,   y, z));
							}
							if (east == 0) {
								this.add_quad(
									new Coord3d(x+1, y+1, z+1),
									new Coord3d(x+1, y,   z+1),
									new Coord3d(x+1, y,   z),
									new Coord3d(x+1, y+1, z));
							}
							if (west == 0) {
								this.add_quad(
									new Coord3d(x, y+1, z+1),
									new Coord3d(x, y,   z+1),
									new Coord3d(x, y,   z),
									new Coord3d(x, y+1, z));
							}
						}
					}
				}
			}
		}

		private void add_quad(Coord3d a, Coord3d b, Coord3d c, Coord3d d) {
			// I think this is right...
			this.__triangles += new Triangle<Coord3d>(a, b, c);
			this.__triangles += new Triangle<Coord3d>(a, c, d);
		}
	}
}