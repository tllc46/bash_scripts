#!/bin/bash

lat0=35.7684 #중심 위도
lon0=129.229 #중심 경도
hor=160 #최대 각거리[degree]
di=10c #지름
event_file=events
file=event_plot

gmt begin $file png
	gmt set FORMAT_GEO_MAP +D
	gmt coast -JAeqd/$lon0/$lat0/$hor/$di -Rg -Gdarkgray
	cut -d '|' -f 3,4 --output-delimiter=' ' $event_file | gmt plot -Gblue -Sc0.07c -:
	gmt basemap -JPolar/$di+a -R0/360/0/$hor -Bxa30g30 -Byg30
gmt end
