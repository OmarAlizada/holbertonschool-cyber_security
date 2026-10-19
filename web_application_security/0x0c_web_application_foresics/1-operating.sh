#!/bin/bash
# Print the kernel version recorded in the supplied boot log.

if [ $# -gt 0 ]
then
	log_file=$1
else
	log_file=dmesg
fi

if [ ! -r "$log_file" ]
then
	printf 'Cannot read log file: %s\n' "$log_file" >&2
	exit 1
fi

grep -m 1 'Linux version ' "$log_file"
