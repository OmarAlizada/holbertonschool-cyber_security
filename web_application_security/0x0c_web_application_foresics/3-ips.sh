#!/bin/bash
# 3-ips.sh - Count the distinct attackers that gained access
#
# Every unique IP address is considered a different attacker.
# The intruders broke into the box by logging in as the
# compromised account (root), so the successful root logins are
# extracted and the unique source addresses are counted.
#
# Usage: ./3-ips.sh [auth.log]

FILE=${1:-auth.log}

grep "Accepted password for root" $FILE \
    | grep -oE "from [0-9.]+" \
    | sort -u \
    | wc -l
