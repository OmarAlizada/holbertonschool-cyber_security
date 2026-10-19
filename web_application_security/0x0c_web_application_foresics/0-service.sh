#!/bin/bash
# 0-service.sh - Identify the service used by the attackers
#
# Scans the authentication log and ranks the messages emitted by
# the service that handled the connections. The dominant entry
# (pam_unix(sshd:auth)) proves that the SSH daemon was the service
# abused to gain access to the system.
#
# Usage: ./0-service.sh [auth.log]

FILE=${1:-auth.log}

grep sshd $FILE | awk '{print $6}' | sort | uniq -c | sort -rn
