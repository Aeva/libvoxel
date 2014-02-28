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


	private void fill_recursion(VoxelModel src, VoxelModel dest, 
								int x, int y, int z,
								int min_x, int min_y, int min_z,
								int max_x, int max_y, int max_z) {
		if (x >= min_x && x <= max_x && 
			y >= min_y && y <= max_y && 
			z >= min_z && z <= max_z &&
			src.read(x,y,z) == 0 && dest.read(x,y,z) == 0)
		{
			dest.add(x,y,z);
			fill_recursion(src, dest, x, y, z-1, min_x, min_y, min_z, max_x, max_y, max_z);
			fill_recursion(src, dest, x, y, z+1, min_x, min_y, min_z, max_x, max_y, max_z);
			fill_recursion(src, dest, x-1, y, z, min_x, min_y, min_z, max_x, max_y, max_z);
			fill_recursion(src, dest, x+1, y, z, min_x, min_y, min_z, max_x, max_y, max_z);
			fill_recursion(src, dest, x, y-1, z, min_x, min_y, min_z, max_x, max_y, max_z);
			fill_recursion(src, dest, x, y+1, z, min_x, min_y, min_z, max_x, max_y, max_z);
		}
	}

	
	public VoxelModel color_fill(VoxelModel src_model) {
		/*
		  This function implements a variation of the color fill /
		  flood fill algorithm, in 3D space.  Instead of altering the
		  original model, it saves the results to a new one and
		  returns it.  The min/max (+1 on each end) values of the
		  source model are assumed to be the "image boundaries".
		  
		  It always starts in one of the corners.
		 */
		var result = new VoxelModel();
		var min_x = src_model.min_x - 1;
		var min_y = src_model.min_y - 1;
		var min_z = src_model.min_z - 1;
		var max_x = src_model.max_x + 1;
		var max_y = src_model.max_y + 1;
		var max_z = src_model.max_z + 1;
		fill_recursion(src_model, result,
					   min_x, min_y, min_z, 
					   min_x, min_y, min_z, max_x, max_y, max_z);
		return result;
	}


	public VoxelModel invert(VoxelModel src_model) {
		/*
		  This function inverts the model passed to it and returns the
		  results.  It assumes the boundaries of the new model are
		  that of the old one.
		 */
		var result = new VoxelModel();

		for (int z=src_model.min_z; z<=src_model.max_z; z+=1) {
			for (int y=src_model.min_y; y<=src_model.max_y; y+=1) {
				for (int x=src_model.min_x; x<=src_model.max_x; x+=1) {
					if (src_model.read(x,y,z) == 0) {
						result.add(x,y,z);
					}
				}
			}
		}

		return result;
	}


	public VoxelModel cast(VoxelModel model) {
		/*
		  Ditch the internal structure of a manifold-appearing model.
		  Returns a model with the same outter topology, but is solid.
		 */
		return invert(color_fill(model));
	}
}