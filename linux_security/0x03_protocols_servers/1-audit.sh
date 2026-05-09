#!/bin/bash
# SSH konfiqurasiya fayllarını audit edən skript

CONFIG_FILE="/etc/ssh/sshd_config"
INCLUDE_DIR="/etc/ssh/sshd_config.d/*.conf"

# Əsas faylı və include edilən faylları birlikdə yoxlayırıq
grep -v '^#' $CONFIG_FILE $INCLUDE_DIR 2>/dev/null | grep -E "KbdInteractiveAuthentication|UsePAM|X11Forwarding|PrintMotd|AcceptEnv|Subsystem|PasswordAuthentication|PermitRootLogin|AuthorizedKeysFile|TCPKeepAlive"
