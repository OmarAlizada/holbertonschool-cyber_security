#!/bin/bash
# Count logged requests to append iptables firewall rules.

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

grep -c 'COMMAND=/sbin/iptables -A ' "$log_file"
