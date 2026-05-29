#!/bin/bash
# Wordlist ilə parolları qırırıq
john --wordlist=/usr/share/wordlists/rockyou.txt "$1"

# Sırf parolları təmiz şəkildə çıxarıb 4-password.txt faylına yazırıq
john --show "$1" | awk -F: '/^[a-f0-9]/ {print $2}' > 4-password.txt
