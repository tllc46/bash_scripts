#!/bin/bash

starttime=2019-11-15,00:00:00.000
endtime=2022-10-12,00:00:00.000
lat=35.7684
lon=129.229
maxradius=95
minradius=25
minmag=5
maxmag=10
event_file=events

FetchEvent -s $starttime -e $endtime --radius $lat:$lon:$maxradius:$minradius --mag $minmag:$maxmag >tmpf1
gawk '!a[$2]++' FS='|' tmpf1 >$event_file # duplicate event 제거
