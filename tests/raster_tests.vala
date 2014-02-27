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


using LibVoxel.Math;
using LibVoxel.Raster;


namespace LibVoxel.Tests {

	private void line_test(string data_path, string export_base) {
		var model = new VoxelModel();

		double low = -10;
		double high = 10;

		var start = new Coord2d(low, low);
		var end = new Coord2d(high, high);
		draw_line(model, start, end, 0);

		stdout.printf("--> Testing line draw function.\n");
		for (int y=(int)low; y<high; y+=1) {
			for (int x=(int)low; x<high; x+=1) {
				int expected = x==y ? 1 : 0;
				assert(model.read(x, y, 0) == expected);
			}
		}
		plot(model, 0);
		
		var export = export_base + "line_raster/"; 
		stdout.printf(@"--> Line rasterization test exported to $export\n");
		export_to_pngs(model, export);
	}


	private void quad_test(string data_path, string export_base) {
		var model = new VoxelModel();

		var a = new Coord2d(-8, 5);
		var b = new Coord2d(10, 10);
		var c = new Coord2d(8, -10);
		var d = new Coord2d(-10, -8);
		var quad = new Quad<Coord2d>(a,b,c,d);

		stdout.printf("--> Testing quad rasterization function.\n");
		quad_raster(model, quad, 0);
		plot(model, 0);

		var export = export_base + "quad_raster/"; 
		stdout.printf(@"--> Quad rasterization test exported to $export\n");
		export_to_pngs(model, export);
	}

	private void quad_test2(string data_path, string export_base) {
		var model = new VoxelModel();

		var a = new Coord2d(-10,  10);
		var b = new Coord2d( 10,  10);
		var c = new Coord2d( 10, -10);
		var d = new Coord2d(-10, -10);
		var quad = new Quad<Coord2d>(a,b,c,d);

		stdout.printf("--> Testing quad rasterization function.\n");
		quad_raster(model, quad, 0);
		plot(model, 0);

		var export = export_base + "quad_raster2/"; 
		stdout.printf(@"--> Quad rasterization test exported to $export\n");
		export_to_pngs(model, export);
	}


	private void frustum_test(string data_path, string export_base) {
		var model = new VoxelModel();

		double min_z = 0;
		double max_z = 3;
		
		stdout.printf("--> Testing frustum rasterization function.\n");

		var front = new Quad<Coord3d>(
			new Coord3d(-8,  8, min_z),
			new Coord3d( 8,  8, min_z),
			new Coord3d( 8, -8, min_z),
			new Coord3d(-8, -8, min_z));

		var back = new Quad<Coord3d>(
			new Coord3d(-2,  2, max_z),
			new Coord3d( 2,  2, max_z),
			new Coord3d( 2, -2, max_z),
			new Coord3d(-2, -2, max_z));
		   
		frustum_raster(model, front, back);
		for (double z=min_z; z<=max_z; z+=1) {
			plot(model, (int)z);
		}

		var export = export_base + "frust_raster.stl"; 
		stdout.printf(@"--> Frustum rasterization test exported to $export\n");
		export_stl(model, export);
	}


	private void frustum_test2(string data_path, string export_base) {
		var model = new VoxelModel();

		double min_z = 0;
		double max_z = 3;
		
		stdout.printf("--> Testing frustum rasterization function.\n");

		var front = new Quad<Coord3d>(
			new Coord3d(-8,  8, max_z),
			new Coord3d( 8,  8, max_z),
			new Coord3d( 8, -8, max_z),
			new Coord3d(-8, -8, max_z));

		var back = new Quad<Coord3d>(
			new Coord3d(-2,  2, min_z),
			new Coord3d( 2,  2, min_z),
			new Coord3d( 2, -2, min_z),
			new Coord3d(-2, -2, min_z));
		   
		frustum_raster(model, front, back);
		for (double z=min_z; z<=max_z; z+=1) {
			plot(model, (int)z);
		}

		var export = export_base + "frust_raster2.stl";
		stdout.printf(@"--> Frustum rasterization test exported to $export\n");
		export_stl(model, export);
	}


	private void frustum_test3(string data_path, string export_base) {
		var model = new VoxelModel();

		double min_z = 0;
		double max_z = 10;
		
		stdout.printf("--> Testing frustum rasterization function.\n");

		var front = new Quad<Coord3d>(
			new Coord3d(-8,  8, max_z),
			new Coord3d( 8,  8, max_z-1),
			new Coord3d( 8, -8, max_z-2),
			new Coord3d(-8, -8, max_z-3));

		var back = new Quad<Coord3d>(
			new Coord3d(-2,  2, min_z+3),
			new Coord3d( 2,  2, min_z+2),
			new Coord3d( 2, -2, min_z+1),
			new Coord3d(-2, -2, min_z));
		   
		frustum_raster(model, front, back);
		for (double z=min_z; z<=max_z; z+=1) {
			plot(model, (int)z);
		}

		var export = export_base + "frust_raster3.stl";
		stdout.printf(@"--> Frustum rasterization test exported to $export\n");
		export_stl(model, export);
	}



	public void raster_tests(string data_path, string export_base) {
		line_test(data_path, export_base);
		quad_test(data_path, export_base);
		quad_test2(data_path, export_base);
		frustum_test(data_path, export_base);
		frustum_test2(data_path, export_base);
		frustum_test3(data_path, export_base);
	}

}
