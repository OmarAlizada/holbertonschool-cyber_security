#!/bin/bash
# 1-operating.sh - Operating system version of the targeted system
#
# The kernel banner is written once at boot and kept as the first
# "Linux version" line of the dmesg output. Printing it reveals
# the exact OS release running on the compromised server.
#
# Usage: ./1-operating.sh [dmesg]

FILE=${1:-dmesg}

grep -m 1 "Linux version" $FILE
