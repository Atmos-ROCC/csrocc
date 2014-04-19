#!/bin/bash

# Written by Daniel Kolkena

version=0.1

# Color variables, courtesy of Kollin
black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'

# Scripted MDS check 
function checkMDS {
	downmds = `rmsview -l mauimds | grep -v up`

	if [[ `echo $downmds | awk '{print length}')` -eq 0 ]];
		then
			echo -e $green"All MDS nodes are up.\n"$white
		else
			echo "The following MDS nodes are down:\n"
			$downmds
	fi
}

checkMDS

exit


# To do:
# Automate check memory usage using "top -n 1 -b | head", 
#   awk relevent values and highlight any CPU% or MEM over threshold.
# 


# Check Gen of node; check ratio 
# nummds = `mount | grep mauimds | wc -l`
# numss = `mount | grep atmos | wc -l`
# if Gen3
# 	if [[nummds != 12 || numss != 48]];
#		echo "Disk missing!"
#	fi
# fi