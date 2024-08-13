get_stations()
{
	network=AU
	station=AS??,INKA
	channel=SHZ,BHZ
	starttime=2020-01-01
 	station_file=station.txt
	wget "https://service.iris.edu/fdsnws/station/1/query?net=$network&sta=$station&cha=$channel&start=$starttime&level=channel&format=text" -O

	#station_file, w/ header
	#knetwk|kstnm|khole|kcmpnm|stla|stlo|stel|stdp|cmpaz|SEEDdip|kinst|scale|Scalefreq|Scaleunits|Samplerate|Start|End
}

get_response()
{
        network=AU
        station=AS??,INKA
        channel=SHZ,BHZ
        starttime=2020-01-01
	FetchData -N $network -S $station -C $channel -s $starttime -rd /media/tllc46/data01/ANT/resp
}

get_events()
{
	starttime=2019-11-15,00:00:00.000
	endtime=2022-10-12,00:00:00.000
	lat=35.7684
	lon=129.229
	maxradius=95
	minradius=25
	minmag=5
	maxmag=10
	event_file=events

	#event_file
	#EventID | o | evla | evlo | evdp | Author | Catalog | Contributor,ContributorID | imagtyp,mag,MagAuthor | kevnm
	FetchEvent -s $starttime -e $endtime --radius $lat:$lon:$maxradius:$minradius --mag $minmag:$maxmag | gawk '!a[$2]++' FS='|' >$event_file #duplicate event 제거
}

get_data()
{
	starttime=2021-01-01
	for((i=0;i<365;i++))
	do
		echo ------------------ progress: downloading $starttime ------------------ >&2
		endtime=${starttime}T23:59:59.975
		year=${starttime:0:4}
        	julday=$(date -d $starttime +%j)
		gawk 'FNR!=1{if($3=="") print $1,$2,"--",$4,"'$starttime'","'$endtime'"; else print $1,$2,$3,$4,"'$starttime'","'$endtime'"}' FS='|' station.txt >post_avail
		if wget "https://service.iris.edu/fdsnws/availability/1/extent" --post-file=post_avail -O avail.txt
		then
			gawk 'FNR!=1&&$10==1{sub("Z","",$7); sub("Z","",$8); print $1,$2,$3,$4,$7,$8}' avail.txt >post_data
			if grep -q 'AU AS' post_data && grep -q 'AU INKA' post_data
			then
				if [ ! -d /media/tllc46/data01/ANT/rawdata/$year.$julday ]
				then mkdir /media/tllc46/data01/ANT/rawdata/$year.$julday
				fi
				wget "https://service.iris.edu/fdsnws/dataselect/1/query" --post-file=post_data -O /media/tllc46/data01/ANT/rawdata/$year.$julday/AU.miniseed
			else echo ------------------ progress: no data in $starttime ------------------ >&2
			fi
		else echo ------------------ progress: no data in $starttime ------------------ >&2
		fi
		starttime=$(date -d "$starttime day" +%Y-%m-%d)
	done
}
