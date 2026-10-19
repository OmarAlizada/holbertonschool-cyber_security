# Web Application Forensics: incident report and mitigations

## Scope and method

This report analyzes the supplied authentication and boot logs using read-only
Bash scripts in this directory. It is a summary for repository review. The
source logs are not committed here. They should be retained in a restricted
case store with acquisition metadata, hashes, access history, and a record of
all transfers. The log timestamps do not provide a consistent year or timezone,
and the records are not globally chronological.

## Findings

| Task | Finding | Evidence basis |
| --- | --- | --- |
| Access service | SSH | SSH daemon authentication and accepted password records |
| Operating system | Linux 2.6.24-26-server, Ubuntu 2.6.24-26.64-server | Kernel boot message |
| Compromised account | root | Successful root SSH password authentication after failures |
| Distinct sources | 18 | Unique source IPs in accepted root password records |
| Firewall activity | 6 | Logged iptables append commands |
| Created accounts | 11 | Unique names in user creation records |

The authentication log contains extensive password failures and subsequent
successful privileged access. Some account creation events include UID 0, which
requires urgent owner review. The six firewall entries are command attempts;
command success and actual firewall state require separate verification.
The root source count follows the project's definition. It cannot establish
that each address corresponds to a separate human attacker. The log also
includes routine service-account creation, so all eleven names must be checked
against the system baseline before classifying them.

The supplied material does not include web access logs, a packet capture,
a disk image, or command exit status. The web entry point, exploit method,
exfiltration, and current host state remain unverified. A connection attempt
to the lab jump host failed at DNS resolution in the analysis environment;
the internal target was therefore not reachable for live checks.

## Mitigation and follow-up

1. Preserve the original artifacts and acquire a verified forensic image before
   modifying the system. Limit case evidence access and keep a transfer log.
2. Compare privileged accounts, SSH keys, sudo permissions, scheduled jobs,
   installed software, and home directories against the approved baseline.
3. Rotate exposed credentials from a trusted machine, remove unauthorized
   access after preserving evidence, disable direct root password login, and
   limit SSH to approved sources with MFA where possible.
4. Check the current firewall with approved read-only inspection, then apply a
   reviewed policy. Do not infer active rules from authentication logs alone.
5. Collect web server and application logs to reconstruct the initial entry
   point. Align clocks and correlate events before asserting causation.
6. Rebuild from a trusted image if compromise is confirmed. Patch the OS and
   application stack, centralize tamper-resistant logs, and alert on privileged
   logins, guessing patterns, UID 0 account creation, and firewall changes.

Further interaction must remain within the authorized laboratory. Request the
project's manual QA review after the submission is ready.
