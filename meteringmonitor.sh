#!/bin/bash
# Metering Log Monitor
version=1.0

newprev=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
procprev=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)

while true
do	
	new=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
	proc=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)

	clear
	printf "Metering Logs:\n"
	printf "New:\t\t%d\t(%+d)\n" "$new" "$((new-newprev))"
	printf "Processing:\t%d\t(%+d)\n\n" "$proc" "$((proc-procprev))"

	/opt/cloudcommon/flume/bin/flume shell -c localhost -e getnodestatus | grep -v ACTIVE
	hadoop dfsadmin -report | grep Datanodes 
	hadoop dfsadmin -report | grep Decommission
	
	printf "\nCurrent tail of map_reduce_output.log:\n"
	printf "================================================================================\n"
	tail -5 /opt/cloudcommon/metering/logs/map_reduce_output.log
	printf "================================================================================\n"
	
	newprev=$new
	procprev=$proc
	sleep 5m
done