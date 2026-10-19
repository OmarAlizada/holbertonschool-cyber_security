#!/bin/bash
# Rank SSH log message types to identify the access service.

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

awk '/sshd/ { count[$6]++ }
END { for (item in count) print count[item], item }' "$log_file" | sort -nr
