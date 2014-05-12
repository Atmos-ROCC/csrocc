#!/bin/bash
# Written by Daniel Kolkena, based on work from Bret Miller
# SS Disk Proactive Replacement Script

version=0.5 # Draft, commented out for testing purposes

validuuid='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$' # Regex to confirm a valid UUID

# Data Input
echo "SS Disk Replacement Script"
read -p "Target Host name? (Press Enter to use current host): " target_host_name
	if [[ "$target_host_name" = "" ]]; then target_host_name=$HOSTNAME; fi
read -p "FSUUID?: " fsuuid
	if ! [[ $fsuuid =~ $validuuid ]]; then echo "Not a valid FSUUID. Exiting."; exit 0; fi 																
echo

# Finding other variables
atversion=$(rpm -qa atmos | cut -c 7-11)
master=$(ssh "$target_host_name" show_master.py | grep System | awk -F " " '{print $3}')
path=$(df -h | grep "$fsuuid" | awk '{print $1}')
diskidx=$(ls /var/local/maui/atmos-diskman/INDEX/ | grep "$fsuuid" | cut -d : -f2 | cut -d . -f1)
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
	echo "Proceeding with disk replacement."
	# Here's where the magic happens
	# TESTING MODE: DISPLAYING COMMANDS ONLY
	echo "mauirexec \"mauisvcmgr -s mauicc -c trigger_cc_rcvrtask -a 'queryStr=\"DISKID-$target_host_name:$diskidx\",act=ConsCheck,taskId=$target_host_name:$diskidx'\" "
	echo "mauirexec \"mauisvcmgr -s mauicc -c query_cc_rcvrtask -a 'taskId=$target_host_name:$diskidx' | grep status=\" "
	echo "psql -U postgres rmg.db -h $master -c \"select uuid from disks where nodeuuid='$nodeuuid' and devpath='$path'\" "
	
	# Validate success here
	# if invalid; echo "Disk replacement unsuccessful"; exit 1; 
	# else echo "Proactive disk replacement begun."		# To do: Test disk replacement logic, add error handling for unsuccessful replacement
	# fi
	
elif [[ $ans = [Nn] ]];
	then
	echo "Disk replacement cancelled."
else
	echo "Response was not 'y' or 'n'. Exiting."
	exit 1
fi

exit 0
