#!/bin/bash

file=plothist

gmt begin $file png
	brange=$(gmt info histo.dat -T0.02)
	xrange=($(gmt info histo.dat -C -I0.02))
	ymax=$(gmt histogram histo.dat $brange -F -I -o3)
	gmt histogram histo.dat -JX10c/16c $brange -Bx0.1 -By10 -F -Gblue -R${xrange[0]}/${xrange[1]}/0/$ymax
gmt end
