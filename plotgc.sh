#!/bin/bash

bds=($(cat boundgc.gmt))
file=plotgc

gmt begin $file png
	gmt set FORMAT_GEO_MAP D
	gmt xyz2grd grid2dvgc.z -Ggrid2dvgc.grd -I${bds[4]}+n/${bds[5]}+n -R${bds[0]}/${bds[1]}/${bds[2]}/${bds[3]} -ZLB
	crange=$(gmt grdinfo grid2dvgc.grd -T0.05+s)
	gmt makecpt -Cpolar -I $crange -Z
	gmt grdimage grid2dvgc.grd -Jx4c/0.5c -Bx1 -By5
	gmt colorbar -B0.1 -B+l"dVp (km/s)" -DJBC+w8c/0.4c
gmt end
