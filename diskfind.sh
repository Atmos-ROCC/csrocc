#!/bin/bash

# Disk Finder
# Takes as input a Serial number, and returns the devpath and node of a disk.

read -p "Serial Number: " serial; fsuuid=$(psql -U postgres -d rmg.db -h $(show_master.py | grep System | awk -F " " '{print $3}') -c "select * from fsdisks where diskuuid='$serial';" | awk 'NR==3' | awk -F " " '{print $5}'); devpath=$(psql -U postgres -d rmg.db -h $(show_master.py | grep System | awk -F " " '{print $3}') -c "select fspath from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); host=$(psql -U postgres -d rmg.db -h $(show_master.py | grep System | awk -F " " '{print $3}') -c "select hostname from filesystems where uuid='$fsuuid';" | awk 'NR==3' | awk -F " " '{print $1}'); echo "Drive $devpath is on host $host."; unset serial; unset fsuuid; unset devpath; unset host;
