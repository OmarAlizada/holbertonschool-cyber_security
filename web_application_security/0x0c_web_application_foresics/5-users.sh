#!/bin/bash
# List unique account names created in the authentication log.

if [ $# -gt 0 ]
then
    log_file=$1
else
    log_file=auth.log
fi

if [ ! -f "$log_file" ]
then
    printf 'Log file not found: %s\n' "$log_file" >&2
    exit 1
fi

grep 'new user: name=' "$log_file" |
    sed -n 's/.*new user: name=\([^,]*\),.*/\1/p' |
    LC_ALL=C sort -u |
    paste -sd, -
