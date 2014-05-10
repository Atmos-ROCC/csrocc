#!/bin/bash
# SS Disk Proactive Replacement Script

version=0.3 # Third Draft, commented out for testing purposes

# Data Input
echo "SS Disk Replacement Script"
read -p "Target Host name?: " target_host_name
read -p "FSUUID?: " fsuuid
echo ""

# Finding other variables
atversion=$(rpm -qa atmos | cut -c 7-11)
master=$(ssh "$target_host_name" show_master.py | grep System | awk -F " " '{print $3}')
path=$(df -h | grep "$fsuuid" | awk '{print $1}')
diskidx=$(ls -l /var/local/maui/atmos-diskman/INDEX/ | grep "$fsuuid" | cut -d : -f2 | cut -d . -f1)
nodeuuid=$(psql -U postgres rmg.db -h "$master" -c "select uuid from nodes where hostname='"$target_host_name"'" | awk 'NR==3' | cut -c 2-37)

# Verification Step
echo "Atmos version is: $atversion"
echo "Host node is: $target_host_name"
echo "Master node is: $master"
echo "Disk Path is: $path"
echo "Disk FSUUID is: $fsuuid"
echo "Disk ID is: $diskidx"
echo "Node UUID is: $nodeuuid"
echo ""
read -p "Does this information look correct? (y/n): " ans

if [[ $ans = [Yy] ]];
	then
	echo "Proceeding with disk replacement."
	# Here's where the magic happens
	# mauirexec "mauisvcmgr -s mauicc -c trigger_cc_rcvrtask -a 'queryStr=\"DISKID-$target_host_name:$diskidx\",act=ConsCheck,taskId=$target_host_name:$diskidx'" 
	# mauirexec "mauisvcmgr -s mauicc -c query_cc_rcvrtask -a 'taskId=$target_host_name:$diskidx' | grep status="
	# psql -U postgres rmg.db -h $MASTER -c "select uuid from disks where nodeuuid='$nodeuuid' and devpath='$path'"
elif [[ $ans = [Nn] ]];
	then
	echo "Disk replacement cancelled."
else
	echo "Response was not 'y' or 'n'. Exiting."
fi

exit 0