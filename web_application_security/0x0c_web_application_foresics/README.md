# Web Application Forensics

This directory contains read-only log analysis scripts and the incident report in
`6-future-mitigations.md`. Run the scripts from this directory with `auth.log`
and `dmesg` present, or pass a log path as the first argument.

| Task | Script | Verified output on the supplied artifacts |
| --- | --- | --- |
| 0 | `0-service.sh` | SSH log-message ranking, headed by 34,806 authentication entries |
| 1 | `1-operating.sh` | Linux 2.6.24-26-server, Ubuntu 2.6.24-26.64-server |
| 2 | `2-accounts.sh` | root |
| 3 | `3-ips.sh` | 18 unique source IPs with accepted root password logins |
| 4 | `4-firewall.sh` | 6 recorded iptables append commands |
| 5 | `5-users.sh` | 11 unique accounts named in user creation records |

Task 3 implements the project's expected count for root access. The log records
29 unique IPs across all successful SSH accounts. An accepted login is evidence
of access, not proof that a particular IP belongs to a distinct human attacker.
Task 4 counts commands in the log, not verified rules in the active firewall.

The scripts only read files and print results. No log, firewall or user account
is modified. The supplied copies were tested locally. Live access to the lab
host was unavailable because its SSH hostname could not be resolved from the
execution environment; this is recorded in the report.
