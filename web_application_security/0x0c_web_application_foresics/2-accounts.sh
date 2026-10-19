#!/bin/bash
# 2-accounts.sh - Detect the compromised account
#
# Analyses the last 1000 lines of the authentication log looking
# for an account that suffered failed password attempts and then
# obtained a successful login: that pattern identifies the
# credentials that were brute-forced and taken over.
#
# Usage: ./2-accounts.sh [auth.log]

FILE=${1:-auth.log}

tail -n 1000 $FILE | awk '
    $6 == "Failed" {
        if ($9 != "invalid")
            failed[$9] = 1
    }
    $6 == "Accepted" {succeeded[$9] = 1}
    END {
        for (account in failed)
            if (account in succeeded)
                print account
    }'
