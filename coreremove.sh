#!/bin/bash
#Core remover

logdir="/var/log/maui"

echo "Checking log directory..."
pretotal=$(ls -l $logdir | wc -l)
echo "There are $pretotal logs in the $logdir directory."

echo "Deleting files..."
# find $logdir -mindepth 2 -name "*core*" -size +10M -type f -delete # Find all files in $logdir with name "*core*" greater than 10 MB and delete all files recursively.

posttotal=$(ls -l $logdir | wc -l); diff=$(pretotal - posttotal)
echo "There are $posttotal logs in the $logdir directory. $diff logs were deleted."
exit 0