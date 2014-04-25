#!/bin/bash
#Core remover

logdir = "/var/log/maui"
echo "Checking log directory..."
pretotal = $(ls -l $logdir | wc -l)
echo "There are $pretotal logs in the //maui directory."
echo "Deleting files"
#rm -rf $logdir
posttotal = $(ls -l $logdir | wc -l)
diff = $pretotal - $posttotal
echo "There are $posttotal logs in the //maui directory."
echo "$diff logs were deleted."
exit 0