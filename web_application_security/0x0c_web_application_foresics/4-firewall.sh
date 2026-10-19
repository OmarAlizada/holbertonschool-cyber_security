#!/bin/bash
# 4-firewall.sh - Count the rules added to the firewall
#
# Firewall administration is done through iptables commands
# executed with sudo, and every command is recorded in the
# authentication log. Rules added to the INPUT chain appear as
# "iptables -A" (append) entries, so counting them gives the
# number of rules the intruders added.
#
# Usage: ./4-firewall.sh [auth.log]

FILE=${1:-auth.log}

grep -c "iptables -A" $FILE
