#!/bin/bash
# Identify the root account with successful SSH password access.

if [ $# -gt 0 ]
then
	log_file=$1
else
	log_file=auth.log
fi

if [ ! -r "$log_file" ]
then
	printf 'Cannot read log file: %s\n' "$log_file" >&2
	exit 1
fi

awk '/sshd\[[0-9]+\]: Accepted password for root from / { found = 1 }
END { if (found) print "root" }' "$log_file"
