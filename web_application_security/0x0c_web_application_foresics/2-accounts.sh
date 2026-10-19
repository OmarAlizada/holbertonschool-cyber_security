#!/bin/bash
# Locate the root account in the last 1000 authentication events.

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

tail -n 1000 "$log_file" |
    grep -E 'sshd\[[0-9]+\]: Accepted [^ ]+ for root from ' |
    awk '{print $9}' |
    LC_ALL=C sort -u
