#CS ROCC

This is a personal repo to store and develop basic scripts for use in a corporate Linux support environment.

####AutoHotKey.ahk
A basic template for creating hotkeys and hotstrings to speed up a custom workflow, using AutoHotKey.

####coreremove
Status: **Incomplete**

Code snippet designed to quickly remove extraneous generated core dumps

Next step: Figure out reliable rules for core files to filter for them.

####diskfind
Status: **Complete**

Single-line command that takes in a disk serial number and returns the host and devpath of that disk.
	
####healthcheck
Status: **Complete**

Single-line code snippet that automatically checks:
	- On node:
		- The number of MDS disks online
		- The number of SS disks online
		- The state of the node
			Any reason why the node may be degraded via check_node_state.py
		- Any disks that may be in recovery
	- On RMG:
		- The number of MDS nodes offline
		- The number of SS nodes offline

####meteringmonitor.sh
Status: **Complete**

Monitoring script that shows the progress of run_map_reduce.sh. Must be run as Hadoop user on an ACDP metering node.

####myscript.sh
Status: **Incomplete**

WIP draft, to hopefully automate several of the troubleshooting steps most commonly used in diagnosing issues.

####objverify.sh
Status: **Incomplete**

WIP draft to automatically verify object replica sizes.

####ssreplace.sh
Status: **Incomplete**

WIP multipurpose script to be used for proactive ss disk recoveries.
	- Finished: 
		- Function that takes in a disk FSUUID and triggers CC for the first part of the recovery process.
	- In Progress:
		- Command-line argument logic
	- To do:
		- Function to check progress of CC
		- Function to remove disk