#!/bin/bash
# Count SSH-related log messages to identify the targeted service.

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

grep 'sshd' "$log_file" |
    awk '
    {
        offset = index($0, ": ")
        message = substr($0, offset + 2)
        split(message, fields, " ")
        print fields[1]
    }' |
    LC_ALL=C sort |
    uniq -c |
    sort -nr
