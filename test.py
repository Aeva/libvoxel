#!/usr/bin/env python

from gi.repository.LibVoxel import VoxelModel, run_tests




print "\n\n1) Testing voxel model access from python:"

foo = VoxelModel()

magnitude = 100000
for i in range(magnitude):
    foo.add(0,0,0)

print foo.read(0,0,0)
assert foo.read(0,0,0) == magnitude
assert foo.read(1,0,0) == 0


print "--> Success!"
print "\n2) Running in-module test function:\n"
run_tests()

print "--> Done.\n"









