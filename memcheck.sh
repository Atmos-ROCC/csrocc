#!/bin/bash

read -p "Enter process name to check: " name

for pid in $(ps -ef | grep $name| grep -v grep | awk '{print $2}'); do
    if [ -f /proc/$pid/smaps ]; then
            echo "* Mem usage for PID $pid - $(ps -o comm= $pid)"
            echo "-- Size: $(cat /proc/$pid/smaps | grep -m 1 -e ^Size: | awk '{print $2}') kB"
            echo "-- Rss: $(cat /proc/$pid/smaps | grep -m 1 -e ^Rss: | awk '{print $2}') kB"
            echo "-- Pss: $(cat /proc/$pid/smaps | grep -m 1 -e ^Pss: | awk '{print $2}') kB"
            echo "Shared Clean: $(cat /proc/$pid/smaps | grep -m 1 -e '^Shared_Clean:' | awk '{print $2}') kB"
            echo "Shared Dirty: $(cat /proc/$pid/smaps | grep -m 1 -e '^Shared_Dirty:' | awk '{print $2}') kB"
            echo
        else
            echo "No PIDs found"
    fi
done