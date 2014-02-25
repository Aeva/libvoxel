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

using Gee;
namespace LibVoxel {

	
	public class Coord : Object {
		public int x;
		public int y;
		public int z;

		public Coord(int x, int y, int z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}


	public int coord_cmp(Coord lhs, Coord rhs) {
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


	public class VoxelModel : Object {

		// PROPERTIES
		public TreeMap<Coord, uint> __tree;
		public int count { get; private set; default=0; }
	   
		public int? min_x { get; private set; default=null; }
		public int? min_y { get; private set; default=null; }
		public int? min_z { get; private set; default=null; }

		public int? max_x { get; private set; default=null; }
		public int? max_y { get; private set; default=null; }
		public int? max_z { get; private set; default=null; }

		public int? width { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_x - min_x + 1;
			}
		}

		public int? height { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_y - min_y + 1;
			}
		}

		public int? depth { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_z - min_z + 1;
			}
		}

		// METHODS

		construct {
			this.__tree = new TreeMap<Coord, uint>(coord_cmp);
		}

		public uint read(int x, int y, int z) {
			/* Returns the intensity value at a given coordinate. */
			var vec = new Coord(x, y, z);
			return this.__tree[vec];
		}

		public void add(int x, int y, int z) {
			/* 
			   Adds a voxel at the given coordinate or increases the
			   "intensity" value of any voxel already existing at that
			   coordinate 
			*/
			var vec = new Coord(x, y, z);
			var value = this.__tree[vec];
			this.__tree[vec] = value + 1;

			if (this.count == 0) {
				min_x = x;
				min_y = y;
				min_z = z;
				max_x = x;
				max_y = y;
				max_z = z;
			}

			if (value == 0) {
				this.count += 1;
			}

			if (this.count > 1) {
				if (x < min_x) {
					min_x = x;
				}
				if (x > max_x) {
					max_x = x;
				}
				if (y < min_y) {
					min_y = y;
				}
				if (y > max_y) {
					max_y = y;
				}
				if (z < min_z) {
					min_z = x;
				}
				if (z > max_z) {
					max_z = x;
				}
			}
		} 
	}
}