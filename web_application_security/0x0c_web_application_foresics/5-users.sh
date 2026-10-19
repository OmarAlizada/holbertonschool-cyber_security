#!/bin/bash
# List unique users created in the authentication log.

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

sed -n 's/.*new user: name=\([^, ]*\),.*/\1/p' "$log_file" |
	sort -u |
	paste -sd, -
