# Forensic Incident Report — Compromised Linux Server `app-1`

**Case reference:** WAF-0x0c-2026-001
**Report type:** Digital forensics — post-incident reconstruction
**Prepared by:** Security analyst (Holberton School cyber-security lab)
**Classification:** Lab exercise — findings relate exclusively to the
authorized Holberton School environment (`ssh.cod-eu-west-3.hbtn.io`,
internal target `10.42.216.218`). No system outside the lab was touched.

---

## 1. Executive summary

The Linux server `app-1` was compromised through its **SSH service**. An
external actor brute-forced the `root` account and obtained interactive
sessions, after which the intruder(s):

* created persistence accounts, two of them with **UID 0** (`packet`, `Fido`),
* installed IRC backdoor tooling (`eggdrop 1.6.19`, `psybnc`) under
  `/home/dhg/`,
* weakened the host firewall by appending **6 `iptables` INPUT rules** and
  several `ufw` allow rules (Identd/113, DNS/53, telnet/2685),
* archived `/var/log` (`tar -cpzf log.tar.gz log`) and copied `auth.log`
  off the log directory.

At least **18 distinct source IP addresses** successfully authenticated to
the system as `root`; 46 further IPs conducted failed password attacks and
220.151.162.21 alone generated 9,259 failed password attempts. The target ran
an obsolete, end-of-life kernel (Ubuntu 2.6.24-26-server, built 2009), which
had no security updates for the entire attack window.

## 2. Scope and legal framework

* The investigation was performed under the written authorization of the
  Holberton School laboratory exercise (project 3172, "Web Application
  Forensics"). All actions were confined to the lab jump host and the
  provided artifacts.
* Methodology follows **ISO/IEC 27037:2012** (identification, collection,
  acquisition and preservation of digital evidence), **NIST SP 800-86**
  (guide to integrating forensic techniques into incident response) and the
  **Budapest Convention on Cybercrime** principles of proportionality and
  legal authority. Evidence integrity is preserved through cryptographic
  hashing (section 3) and an audit trail of every command executed.

## 3. Evidence inventory

| ID | Item             | Description                                   | Size          | SHA-256 (first 16 / last 16)                     |
| -- | ---------------- | --------------------------------------------- | ------------- | ------------------------------------------------ |
| E1 | `auth.log`       | Syslog authentication log of `app-1`          | 10,415,266 B  | `1be30661d70cc0f7…7b7e9e585fd`                   |
| E2 | `dmesg.pdf`      | Printed kernel ring buffer of the target      | 6,464,847 B   | `f68e28241a587649…7349f1702f70`                  |

`auth.log` contains 102,164 readable syslog lines spanning **May 16 08:12:04**
through **June 26 09:35+**, plus a final block of entries in English locale
(May 2, 23:10–23:11) where the log directory is archived. (The analyst's
working copy was re-downloaded from the official project distribution URL and
hash-verified; a local copy that had grown to 281 MB with an appended binary
tail was excluded as corrupted.) The `dmesg` PDF carries no text layer; the
kernel banner was recovered by OCR of page 1.

## 4. Attack timeline

| When (log time)     | What happened                                                                 | Evidence |
| ------------------- | ---------------------------------------------------------------------------- | -------- |
| May 16 08:12        | Initial provisioning: users `Kayn`, `Nidalee`, `Jax`, `Aphelios` created     | `useradd`, `login`, `sudo` entries |
| May 16 08:25        | System account `sshd` password set by `usermod`                              | `usermod[4846]` |
| Jun (Juin) 15 12:49 | `Jax` rewrites `../templates/proxy/iptables.conf` via `tee` (×4)             | `sudo` COMMAND entries |
| **Juin 19 05:41**   | **`220.151.162.21` logs in as `root` after ~9,259 failed passwords**          | `Accepted password for root` |
| Juin 19 07:01–      | `220.151.162.21` runs dictionary attacks (usernames `firewall`, `eggdrop`…)  | 16,838 log lines from this IP |
| **Juin 19 22:38**   | **Backdoor account `packet` created with UID=0 GID=0, shell `/bin/sh`**      | `useradd[2019]` |
| Juin 19 22:45       | Account `dhg` created                                                        | `useradd[2053]` |
| Juin 19 23:21–23:34 | From `/home/dhg/psybnc-linux/psybnc` and `/home/dhg/eggdrop1.6.19`: `alien`, `dpkg -i lsb-build_4.0.9-2`, `apt-get install tcl8.4 tk8.4` — installation of an IRC bouncer and bot | `sudo` sessions opened for root by `dhg(uid=0)` |
| Juin 20 06:51       | `ufw allow 113/Identd` executed from `/home/dhg/eggdrop`                     | `sudo` COMMAND entries |
| Juin 22–23          | Repeated `/etc/init.d/apache2 start` by `Jax` from `/opt/software/web/app`   | `sudo` COMMAND entries |
| Juin 24 19:27       | Account `messagebus` (re)created, password changed                           | `useradd[1386]`, `usermod[1387]` |
| **Juin 24 20:03–20:11** | **6 `iptables -A INPUT … -j ACCEPT` rules appended** (ports 2424, 53/tcp, 53/udp, ssh, 53/tcp, 113) | `sudo` COMMAND entries, PWD=`/etc` |
| Juin 25 10:41       | **Backdoor account `Fido` created with UID=0**, shell `/bin/sh`             | `useradd[9596]` |
| **Juin 26 04:42**   | `189.132.24.38` (`host-189-132-24-38.hspa.bougybougy.md`): failed password for `root`, then **accepted on the same connection** | `sshd[20096]` |
| Juin 26 04:43       | Account `Senna` created                                                      | `useradd[20115]` |
| Juin 26 08:51       | Same IP again: failed password then accepted for `root`                      | `sshd[23542]` |
| May 2 23:10–23:11   | `Jax` runs `cp auth.log /mnt` and `tar -cpzf log.tar.gz log` — logs archived off-line | `sudo` COMMAND entries |

## 5. Findings (mapped to the exercise tasks)

### 5.1 Attack surface — SSH (`0-service.sh`)

The service scan of `auth.log` is dominated by the SSH daemon:

```
34806 pam_unix(sshd:auth):
20339 Failed
14478 Invalid
  214 Address
  200 pam_unix(sshd:session):
  169 reverse
  118 Accepted
```

70,445 of 102,164 log lines mention `sshd`. Conclusion: the attackers used
**SSH (port 22, password authentication)** to reach the system.

### 5.2 Operating system (`1-operating.sh`)

```
[    0.000000] Linux version 2.6.24-26-server (buildd@crested) (gcc version
4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #1 SMP Tue Dec 1 18:26:43 UTC 2009
(Ubuntu 2.6.24-26.64-server)
```

Ubuntu 8.04-era server kernel, **end of life since 2013** — no patches were
available during the incident window.

### 5.3 Compromised account (`2-accounts.sh`)

Analysing the last 1,000 lines, `root` shows the textbook pattern of repeated
failures followed by success — on June 26, `189.132.24.38` failed a password
for `root` at 08:51:44 and was accepted **on the same SSH connection** at
08:51:50. `root` is the compromised account.

### 5.4 Successful attackers (`3-ips.sh`)

18 distinct IPs obtained a successful `root` session. The most active:

| IP                  | Notable behaviour |
| ------------------- | ----------------- |
| `220.151.162.21`    | 9,259 failed passwords, first root break-in (Juin 19 05:41), huge invalid-user scans |
| `189.132.24.38`     | Fail-then-success root logins on June 26 (compromise proof in last 1,000 lines) |
| `191.167.88.165`    | 23 successful sessions |
| `77.192.196.141`    | 22 successful sessions |
| `10.1.2.3`          | 14 sessions (13 as `Kayn`, 1 as `root`) — internal/lab operator traffic |
| `123.4.51.181`      | `Bad protocol version identification 'GET http://proxyjudge1.proxyfire.net/fastenv HTTP/1.1'` — proxy-reconnaissance |

46 IPs attempted brute force without success; 69 distinct IPs appear in the
log altogether.

### 5.5 Firewall tampering (`4-firewall.sh`)

Six rules were appended to the INPUT chain on June 24 (20:03–20:11) from
PWD `/etc`:

```
iptables -A INPUT -p ssh -dport 2424 -j ACCEPT   # malformed; intent: backdoor port 2424
iptables -A INPUT -p tcp -dport 53  -j ACCEPT
iptables -A INPUT -p udp -dport 53  -j ACCEPT
iptables -A INPUT -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -p tcp --dport 53  -j ACCEPT
iptables -A INPUT -p tcp --dport 113 -j ACCEPT   # Identd, abused by eggdrop
```

`dhg` additionally issued `ufw allow` for 53, 113, 113/Identd, 2685/telnet,
2685/tcp and 22 — widening exposure to exactly the services the IRC tooling
needs.

### 5.6 Created accounts (`5-users.sh`)

```
Aphelios,Debian-exim,Fido,Jax,Nidalee,Senna,dhg,messagebus,mysql,packet,sshd
```

Benign provisioning explains `Nidalee`, `Jax`, `Aphelios` (May 16) and the
service accounts `sshd`, `Debian-exim`, `mysql`, `messagebus`. The
intruder-created set is `packet` (**UID 0**), `dhg`, `Fido` (**UID 0**) and
`Senna` — the two UID-0 accounts are direct, password-less root backdoors.

### 5.7 Anti-forensic activity

The closing entries show `Jax` copying `auth.log` to `/mnt` and packing
`/var/log` into `log.tar.gz` — either evidence removal by the intruder or an
uncontrolled local archive; either way the original log chain on the host is
not trustworthy after that point, reinforcing the need for the remote copy
analysed here.

## 6. Indicators of compromise (IOCs)

* IPs: `220.151.162.21`, `189.132.24.38`, `191.167.88.165`, `77.192.196.141`,
  `9.13.46.243`, `123.4.51.181`, `66.209.123.49` (full list derivable from
  `grep 'Accepted password for root' auth.log`).
* Accounts: `packet` (UID 0), `Fido` (UID 0), `dhg`, `Senna`.
* Paths: `/home/dhg/eggdrop1.6.19`, `/home/dhg/psybnc-linux/psybnc`,
  `lsb-build_4.0.9-2.src.rpm`, `/var/log/log.tar.gz`, `/mnt/auth.log`.
* Network: open ports 2424, 2685 (telnet/tcp), 113/Identd, 53.
* Log signatures: `user NOT in sudoers` followed by root sessions
  (`dhg(uid=0)`), `Bad protocol version identification 'GET http://…'`,
  fail-then-success `Failed/Accepted password for root` pairs.

## 7. Root cause analysis

1. SSH exposed to the Internet with **root password authentication enabled**
   and no rate limiting — a 9,259-attempt dictionary attack succeeded.
2. An obsolete kernel (2.6.24, EOL 2013) offered no mitigations.
3. Weak/known root password (the same source returned within minutes on
   June 26), suggesting the credential remained guessable or was re-used.
4. Excessive local privilege (`sudo` used to install untrusted RPMs via
   `alien`, rewrite `iptables.conf`, and archive logs) with no separation of
   duties.

## 8. Impact assessment

* Confidentiality: full root compromise; entire filesystem and logs exposed.
* Integrity: accounts and firewall rules modified; logs archived/removed.
* Availability: rogue services (eggdrop, psybnc, open telnet port 2685)
  consume resources and may be used for further attacks.
* Legal exposure: the host could have been used as a pivot; data handling
  obligations (e.g. GDPR if EU personal data was present) must be assessed.

## 9. Recommendations

**Immediate**

1. Rebuild from trusted media; the host cannot be declared clean after root
   compromise and log archival.
2. Remove/rotate all credentials; deploy key-based SSH with
   `PermitRootLogin no`, `PasswordAuthentication no`, and 2FA.
3. Delete backdoor accounts `packet` and `Fido` (UID 0) and audit every
   `/home/*/authorized_keys`.
4. Flush the 6 injected `iptables` rules and the `ufw` allowances; re-enable
   a default-deny policy with explicit business rules only.
5. Quarantine `/home/dhg`, `/var/log/log.tar.gz` and `/mnt/auth.log` as
   evidence before deletion.

**Structural**

6. Patch/upgrade to a supported OS release; subscribe to security updates.
7. Deploy `fail2ban`/rate limiting and centralize logs on a remote, append-
   only SIEM so local tampering is detectable.
8. Apply least privilege: restrict `sudo` to named administrative accounts,
   log all root sessions to the SIEM.
9. Monitor for the IOCs in section 6 (egress to known C2 ranges, unexpected
   listening ports, new UID-0 accounts).
10. Schedule periodic compromise assessments (e.g. authorized scans of
    exposed services) and rehearse this playbook annually.

## 10. Conclusion

The evidence in `auth.log` and `dmesg` reconstructs a complete intrusion
chain: SSH brute force of `root` (service `sshd`, Ubuntu 2.6.24-26-server),
persistence through UID-0 accounts and IRC backdoors, firewall weakening with
6 injected rules, and post-exploitation log archival. 18 distinct attackers
gained interactive access. Eradication requires a full rebuild plus the hard-
ening measures above; the accompanying scripts `0-service.sh` … `5-users.sh`
reproduce every quantitative claim in this report directly from the raw
artifacts.

---

*Report generated for the Holberton School Web Application Forensics lab
(project 3172), tasks 0–6. All analysis was performed on the provided
artifacts within the authorized lab boundary.*
