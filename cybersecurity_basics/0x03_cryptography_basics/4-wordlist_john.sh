#!/bin/bash
# Həmişə eyni nəticəni verməsi üçün əvvəlki potesial keşləri təmizləyirik
john --show "$1" > /dev/null 2>&1

# Wordlist ilə parolları qırırıq
john --wordlist=/usr/share/wordlists/rockyou.txt "$1" > /dev/null 2>&1

# Parolları çıxarırıq: ":" simvolundan sonrakı hissəni götürürük, boş sətirləri və John-un statistikalarını silirik
john --show "$1" | grep -E '^[a-f0-9]+:' | cut -d':' -f2 | grep -v '^$' > 4-password.txt
