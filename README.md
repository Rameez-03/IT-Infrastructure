# IT Infrastructure — SOCLab Windows Environment

This repository documents the build and configuration of the Windows infrastructure component of a home SOC lab. It covers the full setup of an Active Directory domain (`soclab.local`) running across three VMs on an MSI laptop, designed for both attack simulation and IT portfolio demonstration.

This environment is the **target/victim side** of the lab. The attacker tooling, Kali Linux, and Wazuh SIEM stack live in the companion project:

> **[SOC-Lab](https://github.com/Rameez-03/SOC-Lab)** — Wazuh SIEM, attack tooling, and detection engineering

---

## What This Builds

A realistic enterprise Windows environment with intentional misconfigurations for red team/blue team practice:

| VM | Role | OS | IP |
|---|---|---|---|
| DC01 | Domain Controller, DNS | Windows Server 2022 | 192.168.0.10 |
| SRV01 | File Server, IIS, ADCS | Windows Server 2019 | 192.168.0.20 |
| WS01 | Domain Workstation | Windows 10 Pro | 192.168.0.30 |

All VMs run in VirtualBox with Bridged Networking and ship logs to the Wazuh manager at `192.168.0.61` via Wazuh agents.

---

## Domain Design

**Domain:** `soclab.local` | **NetBIOS:** `SOCLAB` | **Functional Level:** Windows Server 2016

### Organisational Units
```
soclab.local
├── IT
├── HR
├── Finance
├── Servers
├── Workstations
├── ServiceAccounts
└── Disabled
```

### Users

| Username | Password | OU | Role | Notes |
|---|---|---|---|---|
| administrator | (set at install) | — | Built-in Domain Admin | Legitimate admin use |
| itadmin | `ITAdmin2024!` | IT | Domain Admin | Named IT admin account |
| helpdesk1 | `Helpdesk1!` | IT | Help Desk | Delegated password reset on HR/Finance OUs only |
| jsmith | `Welcome1!` | HR | Standard domain user | Local admin on WS01 only |
| awhite | `Welcome1!` | Finance | Standard domain user | No special rights |
| bjones | `Welcome1!` | HR | Standard domain user | No special rights |
| svc_backup | `Backup2024!` | ServiceAccounts | Service account | SPN set → Kerberoasting target |
| svc_scan | `Scan2024!` | ServiceAccounts | Service account | Pre-auth disabled → AS-REP Roasting target |
| svc_iis | `IIS2024!` | ServiceAccounts | IIS app pool identity on SRV01 | SeImpersonatePrivilege → Potato attacks |

### Security Groups

| Group | Members | Purpose |
|---|---|---|
| IT-Admins | itadmin | Full domain admin group |
| Help-Desk | helpdesk1 | Delegated password reset |
| HR-Users | jsmith, bjones | Access to HR share |
| Finance-Users | awhite | Access to Finance share |
| Data-ReadWrite | jsmith, awhite, bjones | Access to shared Data folder |
| Backup-Operators-Lab | svc_backup | Backup rights |

---

## Intentional Misconfigurations

These are deliberately insecure to generate realistic attack paths and SOC detections:

| Misconfiguration | Attack Technique |
|---|---|
| `svc_backup` has SPN set | Kerberoasting |
| `svc_scan` has pre-auth disabled | AS-REP Roasting |
| `jsmith → WriteDACL → HR-Users → GenericAll → svc_backup → DCSync` | ACL abuse chain (BloodHound) |
| SMB signing disabled on WS01 and SRV01 | NTLM relay |
| WinRM enabled on WS01 and SRV01 | Lateral movement |
| Unconstrained delegation on SRV01 | Delegation abuse |
| Print Spooler running on DC01 | NTLM coercion (PetitPotam / SpoolSample) |
| ADCS ESC1 vulnerable certificate template | Certificate-based privilege escalation |
| Shared local admin password (`LocalAdmin2024!`) on all machines | No LAPS — pass-the-hash |
| Weak password policy (min 7 chars, no complexity, no lockout) | Password spraying |
| NTLMv1 not disabled | Downgrade attacks |
| Fake `credentials.txt` in `\\SRV01\Data` | Discovery simulation |

---

## Build Phases

| Phase | What Happens |
|---|---|
| 1 | Build DC01 — domain promotion, OUs, users, groups, GPOs, ACL chain |
| 2 | Build SRV01 — domain join, file shares, IIS, ADCS |
| 3 | Domain join WS01 — configure workstation, disable SMB signing |
| 4 | Group Policy Objects — drive mapping, screensaver, security baseline |
| 5 | Sysmon on all VMs — SwiftOnSecurity config, feed to Wazuh |
| 6 | Verification — AD health, share access, misconfig checks, BloodHound |

Full step-by-step build notes: [HANDOFF-MSI.md](HANDOFF-MSI.md)

---

## IT Demonstration Scenarios

Beyond the attack surface, this environment supports sysadmin and help desk portfolio demonstrations:

- New employee onboarding
- Password reset and delegation boundary testing
- Account unlock and lockout source identification
- Group membership changes and share access verification
- Remote Desktop support sessions
- GPO creation, linking, and troubleshooting
- DNS record management
- Certificate enrollment via ADCS
- File server permission auditing
- Backup and recovery using Windows Server Backup
- IIS site management
- Server health monitoring with Performance Monitor

---

## Network

All VMs use VirtualBox Bridged Networking — they appear directly on the home network (`192.168.0.0/24`). Static IPs are configured in Windows, not via router.

```
192.168.0.10  DC01       (Windows Server 2022 — Domain Controller)
192.168.0.20  SRV01      (Windows Server 2019 — Member Server)
192.168.0.30  WS01       (Windows 10 Pro — Workstation)
192.168.0.61  Wazuh SIEM (Ubuntu — on separate PC, bridged)
```

---

## Related Project

Detection rules, attack playbooks, and SIEM configuration are maintained in the companion repository:

**[https://github.com/Rameez-03/SOC-Lab](https://github.com/Rameez-03/SOC-Lab)**
