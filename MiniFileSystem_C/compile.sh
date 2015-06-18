#!/bin/sh
#
# file:        compile.sh - compile homework 4
#

FLAGS='-D_FILE_OFFSET_BITS=64'

if [ "$1" = "clean" ] ; then
   rm -f *.o homework read-img mkfs-cs5600fs
   exit
fi
gcc $FLAGS -c -g -Wall misc.c
gcc $FLAGS -c -g -Wall homework.c 
gcc $FLAGS -c -g -Wall image.c
gcc -g -Wall -o homework misc.o homework.o image.o -lfuse

gcc -g -Wall -o mkfs-cs5600fs mkfs-cs5600fs.c
gcc -g -Wall -o read-img read-img.c
