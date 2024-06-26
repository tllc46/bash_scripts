#!/bin/bash
#fmtt/example1/gmtplot/plotns 참고

grl=4780 #지구 반지름[km]
bds=($(cat boundns.gmt))
file=plotns

meanr=$(echo "0.5*(${bds[0]}+${bds[1]})" | bc) #중심 위도
bds[2]=$(echo ${bds[2]}+$grl | bc)
bds[3]=$(echo ${bds[3]}+$grl | bc)

gmt begin $file png
	gmt set FORMAT_GEO_MAP D
	gmt xyz2grd grid2dvns.z -Ggrid2dvns.grd -I${bds[4]}+n/${bds[5]}+n -R${bds[0]}/${bds[1]}/${bds[2]}/${bds[3]} -ZRB
	crange=$(gmt grdinfo grid2dvns.grd -T0.05+s)
	gmt makecpt -Cpolar -I $crange -Z
	gmt grdimage grid2dvns.grd -JPolar/15c+a+t$meanr+z -BWrSt -Bx0.01 -By5 -By+l"Depth(km)"
	gmt colorbar -B0.1 -B+l"dVp (km/s)" -DJBC+w8c/0.4c
gmt end
