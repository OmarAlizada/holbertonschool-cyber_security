# 0x0c_web_application_foresics

Web Application Forensics project — scripts that analyse the artifacts of a
compromised Linux server (`auth.log` and `dmesg`) and reconstruct the attack.

## Artifacts

* `auth.log` — 102,164 lines of syslog authentication data from host `app-1`
  (10,415,266 bytes, SHA-256 `1be30661d70cc0f7...7b7e9e585fd`).
* `dmesg` — kernel ring buffer of the target (the project ships it as
  `dmesg.pdf`; text recovered with OCR).

## Scripts

| File            | Question answered                                     | Answer            |
| --------------- | ----------------------------------------------------- | ----------------- |
| `0-service.sh`  | Which service was abused to gain access?              | SSH (`sshd`)      |
| `1-operating.sh`| What is the OS version of the target?                 | Ubuntu 2.6.24-26.64-server |
| `2-accounts.sh` | Which account was compromised?                        | `root`            |
| `3-ips.sh`      | How many distinct attackers gained access?            | 18                |
| `4-firewall.sh` | How many firewall rules were added by the attackers?  | 6                 |
| `5-users.sh`    | Which user accounts were created on the system?       | `Aphelios,Debian-exim,Fido,Jax,Nidalee,Senna,dhg,messagebus,mysql,packet,sshd` |
| `6-report.md`   | Professional forensic incident report                 | —                 |

Every script takes the log file as optional `$1` and defaults to `auth.log`
(or `dmesg` for `1-operating.sh`) in the current directory, so it can be run
as `./0-service.sh` inside the folder holding the artifacts.

## Usage

```bash
chmod +x *.sh
./0-service.sh          # service scan of auth.log
./1-operating.sh        # OS banner from dmesg
./2-accounts.sh         # compromised account (last 1000 lines)
./3-ips.sh              # distinct successful attackers
./4-firewall.sh         # firewall rules added
./5-users.sh            # created accounts, comma separated
```

## Constraints honoured

* First line is exactly `#!/bin/bash`.
* No backticks, `&&`, `||` or `;` in the scripts.
* `$1` is used unquoted (no argument type alterations).
* Files end with a newline, are executable, and follow the Betty style.
