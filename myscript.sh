#!/bin/bash
# Written by Daniel Kolkena

version=0.3.2

# Color variables, courtesy of Kollin
black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'

#Memory thresholds
critical=2097152 #Thresholds are available in /etc/atmos_monitor/monitor_policy.conf

#Help message
if [[ "$1" == "-h" || "$1" == "--help"]];
	then
		echo "" #Summary of program
fi


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

function smartctlalldisks {
	for Q in $(df -h | awk '{print $1}'); do echo $Q; smartctl -a $Q; done | egrep '/dev|SMART overall-health self-assessment test result|Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable'
}


# Automate check memory usage using "top -n 1 -b | head", 
#   awk relevent values and highlight any CPU% or MEM over threshold.
function checkMem {

	# Collecting data
	top -n 1 -b | head -5 >> topsummary.out # top summary
	ps -e -o pmem= -o pcpu= -o pid= -o comm= | sort -rn -k 1 | head -n5 >> topmem.out # top 5 MEM [Nothing should be over 2.4 GB memory]
	ps -e -o pmem= -o pcpu= -o pid= -o comm= | sort -rn -k 2 | head -n5 >> topcpu.out # top 5 CPU%

	# You can trace the offending pid as well, or even dump it into a core for engineering analysis

	cat /proc/meminfo

	# Free memory should be about 200 MB under normal load
	# iostat [-x]
	# uptime [based on memory, iostat]

	# Run checks on the following utilization fields from topsummary.out

	# [Metric CPU Utilization]
	# [Metric Total Memory Utilization]
	# [Metric Physical Memory Utilization]
	# [Metric Swap Memory Utilization]

	# Other possible tests

	# [Metric Atmos Job Service Memory Usage]
	# [Metric Atmos Storage Service Proxy Memory Usage]
	# [Metric Atmos Consistency Checker Memory Usage]
	# [Metric Atmos Storage Service Memory Usage]
	# [Metric Atmos Authentication Service Memory Usage]
	# [Metric Atmos Metadata Location Service Memory Usage]
	# [Metric Atmos Resource Management Service Memory Usage]
	# [Metric Atmos Filesystem Service Memory Usage]
	# [Metric Atmos Cluster Manager Memory Usage]
	# [Metric Network Filesystem Memory Usage]
	# [Metric Apache Server Memory Usage]
	# [Metric Mongrel Server Memory Usage]
	# [Metric Samba Server Memory Usage]
	# [Metric Ganglia Memory Usage]
	# [Metric Event Manager Memory Usage]
	# [Metric Monitor Engine Memory Usage]
	# [Metric Maui CAS Memory Usage]
	# [Metric NTP Memory Usage]
	# [Metric ClasS Memory Usage]
	# [Metric Snmptrapd Memory Usage]
	# [Metric snmpd Memory Usage]
	# [Metric dhcpd Memory Usage]
	# [Metric commonlogd Memory Usage]
	# [Metric dataeng Memory Usage]
	# [Metric Atmos Node Monitor Memory Usage]

	# List of services - emc298107
	# mauiss
	# mauirms
	# mauimds
	# mauimdls
	# mauijs
	# mauifs
	# mauipfs
	# mauicc
	# mauiauthsrv
	# gmond
	# qpidd
	# ssprozy
	# mauicaas
	# spread
	# mongrel
	# gmetad
	# apache2
	# gmondproxy
	# mauisnmp

}


function checkDiskIO { # /pacemaker/cpu_usage.py for some reason
	
	# iostat, grep %iowait, alert for anything >60%

} 



# Clean up all temp files

exit















# To do:

# echo "MDS: `mount | grep atmos | wc -l` SS: `mount | grep mauiss | wc -l` Ratio: `grep -i 'ratio' /etc/maui/node.cfg`"

# Check Gen of node; check ratio 
# nummds=`mount | grep mauimds | wc -l`
# numss=`mount | grep atmos | wc -l`
# if [[Gen3 = true]]
# 	if [[nummds != 12 || numss != 48]];
#		echo "Disk missing!"
#	fi
# fi
#
# Mine /usr/local/xdoctor/pacemaker for ideas