#!/bin/bash
whois "$1" | awk -F ": " '/^(Registrant|Admin|Tech)/ {k=$1; sub(/^[ \t]+/, "", k); sub(/[ \t]+$/, "", k); v=$2; sub(/^[ \t]+/, "", v); sub(/[ \t]+$/, "", v); if (k ~ /Ext$/) k=k ":"; if (k ~ /Street$/ && v != "") v=v " "; lines[++count]=k "," v} END {for (i=1; i<=count; i++) {if (i==count) printf "%s", lines[i]; else print lines[i]}}' > "$1.csv"
