get_stations()
{
	network=AU
	station=AS??,INKA
	channel=SHZ,BHZ
	starttime=2020-01-01
 	station_file=stations.txt
	wget "https://service.iris.edu/fdsnws/station/1/query?net=$network&sta=$station&cha=$channel&start=$starttime&level=channel&format=text" -O $station_file

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
	starttime=2019-11-15
	endtime=2022-10-12
	latitude=35.7684
	longitude=129.229
	maxradius=95
	minradius=25
	minmagnitude=5
	maxmagnitude=10
	event_file=events.txt

	wget "https://service.iris.edu/fdsnws/event/1/query?start=$starttime&end=$endtime&lat=$latitude&lon=$longitude&maxradius=$maxradius&minradius=$minradius&minmag=$minmagnitude&maxmag=$maxmagnitude&orderby=time-asc&format=text" -O tmpf
 	gawk '!a[$2]++' FS='|' tmpf >$event_file #중복 event 제거
  	rm tmpf

	#event_file, w/ header
	#EventID|o|evla|evlo|evdp|Author|Catalog|Contributor|ContributorID|imagtyp|mag|MagAuthor|kevnm
}

get_data()
{
	station_file=station.txt
 	avail_post_file=avail_post.txt
 	avail_file=avail.txt
  	data_post_file=data_post.txt
 	starttime=2021-01-01

 	for((i=0;i<365;i++))
	do
		echo ------------------ progress: downloading $starttime ------------------ >&2
		endtime=${starttime}T23:59:59.975
		year=${starttime:0:4}
        	julday=$(date -d $starttime +%j)
		gawk 'FNR!=1{if($3=="") print $1,$2,"--",$4,"'$starttime'","'$endtime'"; else print $1,$2,$3,$4,"'$starttime'","'$endtime'"}' FS='|' $station_file >$avail_post_file
		if wget "https://service.iris.edu/fdsnws/availability/1/extent" --post-file=$avail_post_file -O $avail_file
		then
			gawk 'FNR!=1&&$10==1{sub("Z","",$7); sub("Z","",$8); print $1,$2,$3,$4,$7,$8}' $avail_file >$data_post_file
			if grep -q 'AU AS' $data_post_file && grep -q 'AU INKA' $data_post_file
			then
				if [ ! -d /media/tllc46/data01/ANT/rawdata/$year.$julday ]
				then mkdir /media/tllc46/data01/ANT/rawdata/$year.$julday
				fi
				wget "https://service.iris.edu/fdsnws/dataselect/1/query" --post-file=$data_post_file -O /media/tllc46/data01/ANT/rawdata/$year.$julday/AU.miniseed
			else echo ------------------ progress: no data in $starttime ------------------ >&2
			fi
		else echo ------------------ progress: no data in $starttime ------------------ >&2
		fi
		starttime=$(date -d "$starttime day" +%Y-%m-%d)
	done

 	#avail_post_file, w/o header
  	#knetwk kstnm khole kcmpnm b e
  
  	#avail_file, w/ header
	#knetwk kstnm khole kcmpnm iqual SampleRate Earliest Latest Updated TimeSpans Restriction

 	#data_post_file, w/o header
  	#knetwk kstnm khole kcmpnm b e
}
