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


	public class VoxelCoord : Object {
		/*
		  X, Y, and Z are expressed as integers, and coorespond to
		  voxel spacial coordinates.
		 */
		public int x;
		public int y;
		public int z;

		public VoxelCoord(int x, int y, int z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}


	public int coord_cmp(VoxelCoord lhs, VoxelCoord rhs) {
		// Returns negative if lhs < rhs, positive if lhs > rhs, and
		// zero if the are equal.
		
		if (lhs.z < rhs.z) {
			return -1;
		}
		else if (lhs.z > rhs.z) {
			return 1;
		}
		else if (lhs.z == rhs.z) {
			if (lhs.y < rhs.y) {
				return -1;
			}
			else if (lhs.y > rhs.y) {
				return 1;
			}
			else if (lhs.y == rhs.y) {
				if (lhs.x < rhs.x) {
					return -1;
				}
				else if (lhs.x > rhs.x) {
					return 1;
				}
			}
		}
		return 0;
	}


}