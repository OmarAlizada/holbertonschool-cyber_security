#!/bin/bash
# Count unique source IPs in successful root SSH password logins.

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

awk '/sshd\[[0-9]+\]: Accepted password for root from / {
	split($0, source, " from ")
	split(source[2], fields, " ")
	ip[fields[1]] = 1
}
END {
	for (address in ip) total++
	print total + 0
}' "$log_file"
