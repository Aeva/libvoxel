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


	public void test_adding_data() {
		var model = new VoxelModel();

		stdout.printf("Created the tree map.\n");
		
		int samples = 100000;
		for (int i=0; i<samples; i+=1) {
			model.add(0, 0, 0);
		}
		model.add(1, 0, 0);
		int intensity = (int) model.read(0, 0, 0);
		assert(model.count == 2);
		assert(intensity == samples);
		
		stdout.printf("Voxel intensity score at (0, 0, 0): %d\n", intensity);
		
		intensity = (int) model.read(1, 0, 0);
		stdout.printf("Voxel intensity score at (1, 0, 0): %d\n", intensity);

		intensity = (int) model.read(2, 0, 0);
		stdout.printf("Voxel intensity score at (2, 0, 0): %d\n", intensity);

		stdout.printf("Unique coordinates in the model: %d\n", model.count);
	}


	public void main() {
		assert(true);
		test_adding_data();
	}
}