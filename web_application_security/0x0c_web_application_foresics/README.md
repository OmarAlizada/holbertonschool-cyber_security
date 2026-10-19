# Web Application Forensics

Holberton School Cyber Security, forensic log investigation, tasks 0–6.

## Scripts

- 0-service.sh — frequency statistics for SSH service logs
- 1-operating.sh — Linux kernel and Ubuntu build information
- 2-accounts.sh — compromised root account from recent successful SSH events
- 3-ips.sh — unique sources of successful root SSH access
- 4-firewall.sh — count of iptables append commands
- 5-users.sh — newly created account names
- 6-future-mitigations.md — evidence-grounded incident report and prevention plan

Place auth.log and dmesg in this directory, then run ./0-service.sh, ./1-operating.sh, and the remaining executables. Alternatively, pass the file path as first positional argument, such as ./3-ips.sh /path/to/auth.log.

Expected results for the supplied sample logs:

- SSH (sshd)
- Linux 2.6.24-26-server, Ubuntu 2.6.24-26.64-server kernel
- root
- 18 unique sources of accepted root SSH logins
- 6 logged iptables append commands
- Aphelios,Debian-exim,Fido,Jax,Nidalee,Senna,dhg,messagebus,mysql,packet,sshd

Important: 18 addresses do not establish 18 distinct humans, and logging an iptables command does not prove that it was successfully applied.

The source log files are intentionally not committed to this repository. Maintain and analyze forensic copies separately.
