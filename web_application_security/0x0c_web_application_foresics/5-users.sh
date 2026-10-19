#!/bin/bash
# 5-users.sh - List the user accounts created on the system
#
# Whenever useradd creates an account, the authentication log
# records a "new user: name=<account>" line. The account names
# are extracted, sorted and printed as a comma separated list.
#
# Usage: ./5-users.sh [auth.log]

FILE=${1:-auth.log}

grep "new user" $FILE \
    | sed 's/.*name=//' \
    | sed 's/,.*//' \
    | LC_ALL=C sort -u \
    | tr '\n' ',' \
    | sed 's/,$//'

echo
