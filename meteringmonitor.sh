#!/bin/bash
# Metering Log Monitor
# Written by Daniel Kolkena

version=1.2

newprev=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
procprev=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)
i=0 		# Iteration counter
t="5m" 		# Number of minutes between refreshing
max=144 	# Number of loops before the script ends
a=0			# Alert counter
amax=12		# Number of loops before alert procs 

while [[ $i -le $max ]] # Will run a max of 144 iterations of 5 minutes, or 12 hours
do	
	new=$(hadoop fs -ls /meteringlogs/new/ | wc -l)
	proc=$(hadoop fs -ls /meteringlogs/processing/ | wc -l)

	clear
	echo $(date)
	printf "Metering Logs:\n"
	printf "New:\t\t%d\t(%+d)\n" "$new" "$((new-newprev))"
	printf "Processing:\t%d\t(%+d)\n\n" "$proc" "$((proc-procprev))"

	/opt/cloudcommon/flume/bin/flume shell -c localhost -e getnodestatus | grep -v ACTIVE
	hadoop dfsadmin -report | grep Datanodes 
	hadoop dfsadmin -report | grep Decommission
	
	printf "\nCurrent Mapreduce processes:\n"
	printf "================================================================================\n"
	ps -e -o pid= -o comm= -o args | grep mapreduce | grep -v grep | cut -c -80
	# echo "--------------------------------------------------------------------------------"
	# Print related PID process states:
	# for pid in $(ps -e -o pid= -o stat= -o comm= -o args | grep mapreduce | grep -v grep | awk '{print $1}')
	# 	do 
	# 		printf "$pid\t"; cat /proc/$pid/status | grep State
	# 	done					# 4/28 - Commented out until I can figure out what fields are useful in /proc/*/status
	printf "================================================================================\n"

	printf "\nCurrent tail of map_reduce_output.log:\n"
	printf "================================================================================\n"
	tail -5 /opt/cloudcommon/metering/logs/map_reduce_output.log | cut -c -80
	printf "================================================================================\n"

	# Alert timer counter
	if [[ $((new-newprev)) -lt 0 ]]
	then 
		a=0					# If /new falls, reset counter
	else
		a=$(( a + 1 ))		# Increment counter
	fi

	if [[ $a -ge $amax ]] 	# If /new isn't falling for 1 hour, a warning will show
	then
		pids=$(for pid in $(ps -e -o pid= -o stat= -o comm= -o args | grep mapreduce | grep -v grep | awk '{print $1}'); do printf "$pid "; done;)
		printf "\nAlert! The number of logs in /new has not gone down in 1 hour."
		printf "\nConsider running \"kill -9 $pids\b\" on the metering node.\n\n"
	fi

	echo "[Hit CTRL+C to end]"

	echo "$(date): " $new >> monitor.log # Writing output to logfile

	newprev=$new
	procprev=$proc
	i=$(( i + 1 ))
	sleep $t # Refreshes every 5 minutes.
done

echo "Exiting after 12 hours."
exit 0