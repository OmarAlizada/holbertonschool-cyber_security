#!/bin/bash
# Count recorded attempts to append iptables rules.

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

awk '/sudo:.*COMMAND=\/sbin\/iptables -A / { total++ }
END { print total + 0 }' "$log_file"
