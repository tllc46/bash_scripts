#!/bin/bash

lat0=-19.9154
lon0=134.396
di=10c #지름
event_file=events
file=event_rose

gmt begin $file png
	gmt set FORMAT_GEO_MAP +D
 	#gmt rose는 -I option도 one-line에 쓰려면 -format prefix를 뒤에 붙여야 한다
	radius=$(cut -d '|' -f 3,4 --output-delimiter ' ' $event_file | gmt mapproject -Af$lon0/$lat0 -fg -: | gmt rose -A5 -I -i2 -o4 -png dummy)
	cut -d '|' -f 3,4 --output-delimiter ' ' $event_file | gmt mapproject -Af$lon0/$lat0 -fg -: | gmt rose -A5 -Gblue -JXy/$di -R0/$radius/0/360 -i2
	gmt basemap -JPolar/$di+a -R0/360/0/$radius -Bxa30g30 -Byg50
gmt end show
