#!/bin/bash
# Written by Daniel Kolkena, based on work from Bret Miller
# SS Disk Proactive Replacement Script

version=0.9.1

validuuid='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' # Regex to confirm a valid UUID

# Data Input
echo "SS Disk Replacement Script"

triggerCC () {
	read -p "Target Host name? (Press Enter to use current host): " target_host_name
		if [[ "$target_host_name" = "" ]]; then target_host_name=$HOSTNAME; fi
	read -p "FSUUID?: " fsuuid
		if ! [[ $fsuuid =~ $validuuid ]]; then echo "Not a valid FSUUID. Exiting."; exit 0; fi 																
	echo

	# Finding other variables
	atversion=$(rpm -qa atmos | cut -c 7-11)
	master=$(ssh "$target_host_name" show_master.py | grep System | awk -F " " '{print $3}')
	path=$(df -h | grep "$fsuuid" | awk '{print $1}')
	diskidx=$(cat /etc/fstab | grep mauiss | nl | grep "$fsuuid" | awk '{print $1}')
	nodeuuid=$(psql -U postgres rmg.db -h "$master" -c "select uuid from nodes where hostname='"$target_host_name"'" | awk 'NR==3' | cut -c 2-37)

	# Verification Step
	echo "Atmos version is: $atversion"
	echo "Host node is: $target_host_name"
	echo "Master node is: $master"
	echo "Disk Path is: $path"
	echo "Disk FSUUID is: $fsuuid"
	echo "Disk ID is: $diskidx"
	echo "Node UUID is: $nodeuuid"
	echo 
	read -p "Does this information look correct? (y/n): " ans

	if [[ $ans = [Yy] ]];
		then
		echo "Proceeding with CC trigger..."

		# Here's where the magic happens
		mauirexec "mauisvcmgr -s mauicc -c trigger_cc_rcvrtask -a 'queryStr=\"DISKID-$target_host_name:$diskidx\",act=ConsCheck,taskId=$target_host_name:$diskidx'"
		mauirexec "mauisvcmgr -s mauicc -c query_cc_rcvrtask -a 'taskId=$target_host_name:$diskidx' | grep status="
		psql -U postgres rmg.db -h $master -c "select uuid from disks where nodeuuid='$nodeuuid' and devpath='$path'"
		echo "CC trigger begun successfully."

	elif [[ $ans = [Nn] ]];
		then
		echo "CC trigger cancelled."
		exit 0
	else
		echo "Response was not 'y' or 'n'. Exiting."
		exit 1
	fi

	exit 0
}


# Main menu to take in arguments -- WORK IN PROGRESS
while getopts ":a" opt; do
	case "$opt" in
		s)
			# Start the process
			triggerCC
			;;
		c)
			# Check the process
			;;
		r)
			# Remove disk
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
		*)	
			echo "No parameter provided."
			exit 0
			;;	
	esac
done

# To do:
# Build out status check function for CC progress
# Build out disk removal function