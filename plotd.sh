#!/bin/bash

bds=($(cat bounddp.gmt))
file=plotd

gmt begin $file png
	gmt set FORMAT_GEO_MAP D MAP_FRAME_TYPE plain
	gmt xyz2grd grid2dvd.z -Ggrid2dvd.grd -I${bds[4]}+n/${bds[5]}+n -R${bds[0]}/${bds[1]}/${bds[2]}/${bds[3]} -ZLB
	crange=$(gmt grdinfo grid2dvd.grd -T0.05+s)
	gmt makecpt -Cpolar -I $crange -Z
	gmt grdimage grid2dvd.grd -Jxy/200c -Bx0.02 -By0.01
	gmt colorbar -B0.1 -B+l"dVp (km/s)" -DJBC+w8c/0.4c
gmt end
