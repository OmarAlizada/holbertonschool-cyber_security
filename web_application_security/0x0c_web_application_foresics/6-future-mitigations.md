# Incident Investigation and Future Mitigations

**Case:** Suspected Linux server compromise through SSH authentication  
**Source evidence:** Provided auth.log and dmesg files  
**Report prepared:** 19 October 2026  
**Assessment:** High-severity indicators, including direct root logins and newly created UID-0 accounts.

## 1. Purpose and forensic method

Digital forensics preserves, examines, analyzes and reports digital evidence to reconstruct an incident. This investigation examines SSH access, authentication failures, administrator commands, creation of user identities and firewall changes. The original files should be hashed and preserved; all analysis should be conducted on copies, with a documented chain of custody.

The logs indicate an SSH-oriented access path. They do not prove that exploitation of a web application was the initial entry point.

## 2. Findings

| Indicator | Observation |
| --- | --- |
| Service | sshd / SSH |
| Operating system | Linux kernel 2.6.24-26-server, Ubuntu 2.6.24-26.64-server build |
| Authentication | 20,339 SSH entries beginning with Failed, 118 accepted SSH password events |
| Compromised account | root, with 28 accepted SSH logins |
| Distinct root login addresses | 18 |
| Firewall actions | Six iptables -A commands and four ufw disable commands recorded |
| User creation | 11 unique account names |
| Privileged identities | packet created with UID 0 and GID 0; Fido created with UID 0 |
| Other unusual activity | www-data interactive shell changed to /bin/bash |

The 11 names are Aphelios,Debian-exim,Fido,Jax,Nidalee,Senna,dhg,messagebus,mysql,packet,sshd. Several names can represent normal service accounts. Account creation is not automatically evidence of maliciousness, but new UID-0 accounts warrant urgent review.

## 3. Timeline of relevant records

The log uses localized month names without a verified year or timezone. The order of all entries is not strictly chronological.

- Mai 18 10:17:01 — www-data shell changed to /bin/bash.
- Mai 29 13:27:26 — Successful root SSH login from 10.1.2.3, a private source IP.
- Juin 19 05:38:14 — Failed root SSH login from 220.151.162.21; extensive further failures are present.
- Juin 19 05:41:44 — Successful root SSH password login from 220.151.162.21.
- Juin 19 22:38:00 — New packet account, UID 0 and GID 0.
- Juin 19 22:45:13 — New dhg account.
- Juin 20 07:00:30 — ufw disable command recorded.
- Juin 24 20:03–20:11 — Six iptables append commands recorded.
- Juin 25 10:41:44 — New Fido account with UID 0.
- Juin 26 04:43:15 — New Senna account.

The correlation between failed and accepted SSH root authentication supports investigating password guessing or brute force. It does not establish the precise exploit, actor identity, or ownership of an address.

## 4. Incident impact and limitations

Direct privileged access gives an intruder the ability to alter services, sensitive data, users and security controls. However, authorization status, data exfiltration, persistence, lateral movement and application modification are not proven by these two files alone.

Some iptables commands contain suspect argument syntax. Authentication logs record command invocation, not necessarily successful execution. Live firewall configuration or additional records would be required to confirm effective rules. The installed Ubuntu userspace release cannot be uniquely established from the kernel line alone.

## 5. Immediate response plan

1. Activate incident response and preserve volatile evidence before shutdown when safe and authorized.
2. Acquire verified copies of disks, logs, web application artifacts, memory and network evidence with hashes and handling records.
3. Isolate affected systems while keeping an approved forensic access route.
4. Rotate compromised credentials and keys from trusted administrative systems; revoke sessions and review privilege grants.
5. Preserve and investigate packet and Fido, including account metadata, SSH keys, home directories, process artifacts and login history, before removing unauthorized persistence.
6. Examine SSH, sudo, PAM, /etc/passwd, /etc/shadow, sudoers, cron, service configuration, firewall rules and application logs.
7. Rebuild affected assets from verified clean images if trust cannot be restored.

## 6. Long-term hardening and implementation

**Access controls:** Disable direct root password logins, prefer SSH keys and MFA-capable remote access, use named administrative accounts, restrict SSH to approved administration networks, apply least privilege, and monitor for password spraying and brute force.

**Platform:** Upgrade this obsolete kernel and related operating system components to supported releases. Apply documented patches, endpoint detection, application dependency reviews, file integrity monitoring and secure configuration baselines.

**Network:** Maintain a reviewed host firewall baseline with emergency recovery procedures. Record rule changes centrally. Segment privileged administration from application and public networks.

**Web application:** Investigate reverse-proxy, web access, WAF, application error and deployment logs to establish whether the web tier participated. Use secure input handling, controlled releases, secret rotation and dependency security scanning.

## 7. Continuous monitoring protocol

Collect and centralize SSH authentication, sudo, auditd, account changes, firewall modifications, web application events and network egress telemetry. Protect logs from alteration and synchronize system clocks.

**High-priority alerts:** Any new UID-0 identity, direct root SSH login, repeated SSH failures followed by a success, service accounts gaining interactive shells, unapproved ufw disablement or iptables modifications, and new persistence mechanisms.

**Review cadence:** Continuous processing of high-severity alerts through the security team's queue; daily triage review, weekly configuration exceptions, monthly access recertification, and periodic incident response exercises.

**Measurement:** Track time to detect and contain, host telemetry coverage, unauthorized root-equivalent accounts, firewall change approval, missing patches, detection false positives and corrective-action completion.

## 8. Legal and reporting controls

Establish lawful authority for collection and processing. Record collector identity, time/timezone, system identifier, acquisition method, file hashes, evidence transfers, access restrictions, retention and analysis steps. Clearly separate observed log entries from interpretations and uncertainty. Follow applicable legal, contractual and organizational procedures.

## 9. Conclusion

The strongest findings are repeated SSH failures, successful root access from 18 source addresses, additional UID-0 accounts and host firewall changes. Preserve evidence, investigate scope and root cause, contain unauthorized privileged access, modernize the platform and validate detection. Full attribution, successful application of firewall rules and business impact remain undetermined.
