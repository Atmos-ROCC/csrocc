#!/bin/bash
# Metering Log Monitor
version=0.9

newprev=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
procprev=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)

while [ true ]
do	
	new=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
	proc=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)
	
	if [[ $new -lt $newprev ]]; 
		then
			newdiff="-$(newprev - new)"
	elif [[ $new -gt $newprev ]];
		then
			newdiff="+$(new - newprev)"
		else
			newdiff="+0"
	fi

	if [[ $proc -lt $procprev ]]; 
		then
			procdiff="-$(procprev - proc)"
	elif [[ $proc -gt $procprev ]];
		then
			procdiff="+$(proc - procprev)"
		else
			procdiff="+0"
	fi

	clear
	echo "$new ($newdiff)"
	echo "$proc ($procdiff)"
	/opt/cloudcommon/flume/bin/flume shell -c localhost -e getnodestatus | grep -v ACTIVE
	hadoop dfsadmin -report | grep Datanodes 
	hadoop dfsadmin -report | grep Decommission
	
	newprev=$new
	procprev=$proc
	sleep 10

done