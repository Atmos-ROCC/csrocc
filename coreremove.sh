#!/bin/bash

echo; 
corenum=$(find /var/cores -type f | wc -l); echo "Core count: $corenum"; 
echo "/var/cores is $(du -sh /var/cores | awk -F " " '{print $1}')"; 

echo "Deleting cores..."; find /var/cores -type f -mtime +2 -delete; 

newcorenum=$(find /var/cores -type f | wc -l); echo "Core count: $newcorenum"; 
echo "/var/cores is $(du -sh /var/cores | awk -F " " '{print $1}')"; 

echo "$(( corenum - newcorenum )) cores deleted."; 
unset corenum; unset newcorenum; 
exit