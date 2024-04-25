#!/bin/bash

station_file=stations
file=station_plot

gmt begin $file png
	gmt set FORMAT_GEO_MAP D
	range=($(sed -En '2,$p' $station_file | cut -d ',' -f 3-4 | gmt info -C -I0.1))
	range[1]=$(echo ${range[1]}+0.2 | bc)
	sed -En '2,$p' $station_file | cut -d ',' -f 3-4 | gmt plot -R${range[0]}/${range[1]}/${range[2]}/${range[3]} -Jmerc/10c -B0.2 -Gblue -St0.2c
	gmt coast -W
	gmt inset begin -DjBR+o0.1c/0.1c -F+p0.5p -Jmerc/0.5c -R125/130/34/39
		gmt coast -N1 -W
		gmt plot -L -Wblue <<EOF
${range[1]} ${range[2]}
${range[1]} ${range[3]}
${range[0]} ${range[3]}
${range[0]} ${range[2]}
EOF
	gmt inset end
gmt end
