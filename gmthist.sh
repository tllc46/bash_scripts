#!/bin/bash
#fmtt/example1/gmtplot/gmthist 참고

file=plothist

gmt begin $file png
	brange=$(gmt info histo.dat -T0.02)
	xrange=($(gmt info histo.dat -C -I0.02))
	ymax=$(gmt histogram histo.dat $brange -F -I -o3)
	gmt histogram histo.dat $brange -Bx0.1 -By10 -F -Gblue -JXy/10c/16c -R${xrange[0]}/${xrange[1]}/0/$ymax
gmt end
