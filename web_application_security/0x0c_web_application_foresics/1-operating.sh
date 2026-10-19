#!/bin/bash
# Extract kernel and Ubuntu build information from dmesg.

if [ $# -gt 0 ]
then
    log_file=$1
else
    log_file=dmesg
fi

if [ ! -f "$log_file" ]
then
    printf 'Log file not found: %s\n' "$log_file" >&2
    exit 1
fi

grep -m 1 'Linux version ' "$log_file"
