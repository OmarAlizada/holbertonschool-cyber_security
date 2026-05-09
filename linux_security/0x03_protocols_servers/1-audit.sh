#!/usr/bin/env bash
shopt -s nullglob
config_files=(/etc/ssh/sshd_config)
config_files+=(/etc/ssh/sshd_config.d/*.conf)
grep -hvE '^[[:space:]]*#|^[[:space:]]*$' "${config_files[@]}"
