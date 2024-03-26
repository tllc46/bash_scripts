#!/bin/bash

lat0=35.7684 #lat0
lon0=129.229 #lon0
hor=160      #horizon
di=10c       #diameter of map
event_file=events
file=event_plot

gmt begin $file png
  gmt set FORMAT_GEO_MAP +D
  gmt coast -JE$lon0/$lat0/$hor/$di -Rg -Gdarkgray
  cut -d '|' -f 3,4 --output-delimiter=' ' $event_file | gmt plot -Gblue -Sc0.07c -:
  gmt basemap -JP$di+a -R0/360/0/$hor -Bxa30g30 -Byg30
gmt end