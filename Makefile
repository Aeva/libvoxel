export LD_LIBRARY_PATH := $(shell pwd)
export GI_TYPELIB_PATH := $(shell pwd)

# commands
VC = valac
GIR = g-ir-compiler

# file names
SRC = src/*.vala
TEST_SRC = tests/*.vala
TEST_OUT = debug/libvoxel_test

NAMESPACE = LibVoxel
LIBNAME = libvoxel
LIBFILE = $(LIBNAME).so
VERSION = 0.1

GIRFILE = $(NAMESPACE)-$(VERSION).gir
TYPEFILE = $(NAMESPACE)-$(VERSION).typelib

# paths
LIBFLAGS = --pkg gee-0.8 --pkg gio-2.0 --pkg Gdk-3.0 -X -lm

VFLAGS = $(LIBFLAGS) -X -fPIC -X -shared -X -w \
	 --gir=$(GIRFILE) --library=$(LIBNAME) \
	 -o $(LIBFILE) $(SRC)

GIRFLAGS = --shared-library=$(LIBFILE) --output=$(TYPEFILE) $(GIRFILE)

DEBUG_FLAGS = $(LIBFLAGS) -g --save-temps -X -w $(SRC) $(TEST_SRC) -o $(TEST_OUT)



all: libvoxel.so $(TYPEFILE)

libvoxel.so:
	$(VC) $(VFLAGS)

$(TYPEFILE):
	$(GIR) $(GIRFLAGS)

debug:
	mkdir debug
	$(VC) $(DEBUG_FLAGS)
	mv src/*.c debug/
	mv tests/*.c debug/

clean:
	rm -fr $(shell cat .gitignore)
	rm -fr debug
