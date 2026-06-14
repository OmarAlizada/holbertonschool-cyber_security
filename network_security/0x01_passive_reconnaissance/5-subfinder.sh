#!/bin/bash
# Subdomain-ləri ekrana çıxarır və eyni zamanda dövrə salır
subfinder -d "$1" -silent | tee /dev/tty | while read -r sub; do
    # Hər subdomain üçün IP adresini tapır
    ip=$(dig +short "$sub" | tail -n1)
    # Əgər IP tapılarsa, fayla "Host,IP" formatında yazır
    if [ -not -z "$ip" ]; then
        echo "$sub,$ip" >> "$1.txt"
    fi
done
