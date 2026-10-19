#!/bin/bash
# Count unique sources of successful SSH logins as root.

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

grep -E 'sshd\[[0-9]+\]: Accepted [^ ]+ for root from ' "$log_file" |
    awk '{print $(NF - 3)}' |
    LC_ALL=C sort -u |
    wc -l
