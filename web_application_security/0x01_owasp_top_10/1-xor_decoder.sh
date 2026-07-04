#!/bin/bash
echo "${1#\{xor\}}" | base64 -d | python3 -c "import sys; data = sys.stdin.buffer.read(); print(''.join(chr(b ^ 0x5F) for b in data))"
