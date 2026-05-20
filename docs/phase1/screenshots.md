# Phase 1 — DC01 Screenshots

Upload screenshots here as you work through Phase 1. Each entry documents what was captured and why.

---

## 1.1 — VM Created in VirtualBox
- VirtualBox main window showing DC01 in the VM list
- VM Settings → Network showing Bridged Adapter selected

## 1.2 — OS Install
- Windows Server 2022 edition selection screen (Desktop Experience selected)
- First login — Server Manager open on desktop

## 1.3 — Static IP Set
- `ipconfig /all` output showing IP: 192.168.0.10, DNS: 127.0.0.1

## 1.4 — Wazuh Agent
- Wazuh dashboard showing DC01 as **Active**

## 1.5 — Domain Promotion
- PowerShell output of `Install-ADDSForest` completing
- DC01 after reboot — logged in as SOCLAB\Administrator

## 1.6 — DNS Verified
- `Resolve-DnsName dc01.soclab.local` returning 192.168.0.10
- `Resolve-DnsName srv01.soclab.local` returning 192.168.0.20

## 1.7 — OUs Created
- Active Directory Users and Computers showing all 7 OUs under soclab.local

## 1.8 — Users Created
- ADUC showing all users in their correct OUs (IT, HR, Finance, ServiceAccounts)

## 1.9 — Groups Created
- ADUC showing all 6 security groups with correct members

## 1.10 — SPN Set (Kerberoasting)
- `setspn -L svc_backup` output showing both SPN entries

## 1.11 — Pre-auth Disabled (AS-REP Roasting)
- `Get-ADUser svc_scan -Properties DoesNotRequirePreAuth` showing True

## 1.12 — Weak Password Policy
- `Get-ADDefaultDomainPasswordPolicy` showing MinPasswordLength 7, ComplexityEnabled False

## 1.13 — Audit Policy GPO
- Group Policy Management showing Lab-Audit-Policy linked to soclab.local
- GPO Editor showing Advanced Audit Policy settings configured

## 1.14 — Firewall Policy GPO
- GPO Editor showing Windows Defender Firewall enabled for all profiles
- Inbound rules showing RDP and WinRM restrictions

## 1.15 — ACL Chain
- PowerShell output confirming all 3 ACL rules applied without errors

## 1.16 — Helpdesk Delegation
- ADUC Delegate Control wizard completion for OU=HR
- ADUC Delegate Control wizard completion for OU=Finance

## 1.17 — Print Spooler Running
- `Get-Service Spooler` output showing Status: Running
