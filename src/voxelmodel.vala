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


	public interface IVoxelModel : Object {

		public abstract int count { get; protected set; }
		public abstract int? min_x { get; protected set; }
		public abstract int? min_y { get; protected set; }
		public abstract int? min_z { get; protected set; }
		public abstract int? max_x { get; protected set; }
		public abstract int? max_y { get; protected set; }
		public abstract int? max_z { get; protected set; }

		// Mixins:
		public virtual int? width { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_x - min_x + 1;
			}
		}
		public virtual int? height { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_y - min_y + 1;
			}
		}
		public virtual int? depth { 
			get {
				if (this.count == 0) {
					return null;
				}
				return max_z - min_z + 1;
			}
		}
	}



	
	public class VoxelModel : Object, IVoxelModel {

		// Properties from the IVoxelModel interface
		public int count { get; protected set; default=0; }
		public int? min_x { get; protected set; default=null; }
		public int? min_y { get; protected set; default=null; }
		public int? min_z { get; protected set; default=null; }
		public int? max_x { get; protected set; default=null; }
		public int? max_y { get; protected set; default=null; }
		public int? max_z { get; protected set; default=null; }

		// Non-interface Properties:
		public TreeMap<VoxelCoord, IVoxelData?> __tree;


		// Methods:

		construct {
			this.__tree = new TreeMap<VoxelCoord, IVoxelData?>(coord_cmp);
		}


		public uint read(int x, int y, int z) {
			/* 
			   Returns the intensity value at a given coordinate.
			*/

			var vec = new VoxelCoord(x, y, z);
			IVoxelData? datum = this.__tree[vec];
			if (datum == null) {
				return 0;
			}
			return datum.samples;
		}


		public void add(int x, int y, int z) {
			/* 
			   Adds a voxel at the given coordinate or increases the
			   "intensity" value of any voxel already existing at that
			   coordinate 
			*/

			if (this.count == 0) {
				this.min_x = x;
				this.min_y = y;
				this.min_z = z;
				this.max_x = x;
				this.max_y = y;
				this.max_z = z;
			}

			var vec = new VoxelCoord(x, y, z);
			IVoxelData? datum = this.__tree[vec];
			if (datum == null) {
				datum = new VoxelData();
				this.__tree[vec] = datum;
				this.count += 1;

				if (x < min_x) {
					this.min_x = x;
				}
				if (x > max_x) {
					this.max_x = x;
				}
				if (y < min_y) {
					this.min_y = y;
				}
				if (y > max_y) {
					this.max_y = y;
				}
				if (z < min_z) {
					this.min_z = x;
				}
				if (z > max_z) {
					this.max_z = x;
				}
			}
			datum.samples += 1;
		}
	}
}