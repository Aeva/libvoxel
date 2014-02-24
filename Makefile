export LD_LIBRARY_PATH := $(shell pwd)
export GI_TYPELIB_PATH := $(shell pwd)

# commands
VC = valac
GIR = g-ir-compiler

# file names
SRC = libvoxel.vala
LIBNAME = libvoxel
GIRFILE = LibVoxel-0.1.gir
TYPEFILE = LibVoxel-0.1.typelib

# paths
LIBFLAGS = --pkg gee-0.8

VFLAGS = -X -fPIC -X -shared -X -w \
	 --gir=$(GIRFILE) \
	 --library=$(LIBNAME) -o $(LIBNAME).so

GIRFLAGS = --shared-library=$(LIBNAME).so --output=$(TYPEFILE) $(GIRFILE)

SRCSFLAGS =  -H $(LIBNAME).h -C --vapi=$(LIBNAME).vapi --library=$(LIBNAME)




all: libvoxel.so LibVoxel-0.1.typelib c-source

libvoxel.so:
	$(VC) $(LIBFLAGS) $(VFLAGS) $(SRC)

LibVoxel-0.1.typelib:
	$(GIR) $(GIRFLAGS)

c-source:
	$(VC) $(LIBFLAGS) $(SRCSFLAGS) $(SRC)

clean:
	rm -fr $(shell cat .gitignore)
