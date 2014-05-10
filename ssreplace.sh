#!/bin/bash
# SS Disk Proactive Replacement Script

version=0.1 # First Draft, commented out for testing purposes

# Data Input
echo "SS Disk Replacement Script"
read -p "Target Host name?: " TARGET_HOST_NAME
read -p "FSUUID?: " FSUUID
echo ""

# Finding other variables
VERSION=$(rpm -qa atmos | cut -c 7-11)
MASTER=$(ssh $TARGET_HOST_NAME show_master.py | grep System | awk -F " " '{print $3}')
PATH=$(df -h | grep $FSUUID | awk '{print $1}')
DISKIDX=$(ls -l /var/local/maui/atmos-diskman/INDEX/ | grep $FSUUID | cut -d : -f2 | cut -d . -f1)
NODEUUID=$(psql -U postgres rmg.db -h $MASTER -c "select uuid from nodes where hostname='$TARGET_HOST_NAME'" | awk 'NR==3' | cut -c 2-37)

# Verification Step
echo "Atmos version is: $VERSION"
echo "Host node is: $TARGET_HOST_NAME"
echo "Master node is: $MASTER"
echo "Disk Path is: $PATH"
echo "Disk FSUUID is: $FSUUID"
echo "Disk ID is: $DISKIDX"
echo "Node UUID is: $NODEUUID"
echo ""
read -p "Does this information look correct? (y/n): " ANS

if [[ $ANS == "y" || "Y" ]];
	then
	echo "Proceeding with disk replacement."
	# Here's where the magic happens
	# mauirexec "mauisvcmgr -s mauicc -c trigger_cc_rcvrtask -a 'queryStr=\"DISKID-$TARGET_HOST_NAME:$DISKIDX\",act=ConsCheck,taskId=$TARGET_HOST_NAME:$DISKIDX'" 
	# mauirexec "mauisvcmgr -s mauicc -c query_cc_rcvrtask -a 'taskId=$TARGET_HOST_NAME:$DISKIDX' | grep status="
	# psql -U postgres rmg.db -h $MASTER -c "select uuid from disks where nodeuuid='$NODEUUID' and devpath='$PATH'"
elif [[ $ANS == "n" || "Y" ]];
	then
	echo "Disk replacement cancelled."
else
	echo "Response was not 'y' or 'n'. Exiting."
fi

exit 0


ls -l /var/local/maui/atmos-diskman/INDEX/ | grep 7538f32a-da3b-4996-b8e3-6f5323ad8bab | cut -d : -f2 | cut -d . -f1
df -h | grep 7538f32a-da3b-4996-b8e3-6f5323ad8bab | awk '{print $1}'