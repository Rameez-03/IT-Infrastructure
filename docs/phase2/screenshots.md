# Phase 2 — SRV01 Screenshots

---

## 2.1 — VM Created and Static IP Set
- VirtualBox showing SRV01 in VM list
- `ipconfig /all` showing IP: 192.168.0.20, DNS: 192.168.0.10

## 2.2 — Wazuh Agent Installed
- Wazuh dashboard showing SRV01 as **Active**

## 2.3 — Domain Joined
- `Add-Computer` prompt showing credential entry for itadmin
- After reboot: SRV01 System Properties showing domain: soclab.local

## 2.4 — SRV01 Moved to Servers OU (DC01)
- ADUC showing SRV01 computer object in OU=Servers

## 2.5 — Roles Installed
- Server Manager dashboard showing IIS, File Server, Print Server, ADCS roles installed

## 2.6 — File Shares Created
- `Get-SmbShare` output listing Data, HR, Finance, IT shares
- `\\SRV01\Data` open in Explorer showing credentials.txt file

## 2.7 — SMB Signing Disabled
- `Get-SmbServerConfiguration` output showing RequireSecuritySignature: False

## 2.8 — WinRM Enabled
- `winrm enumerate winrm/config/listener` output showing listener active

## 2.9 — IIS Intranet Site
- IIS Manager showing Intranet site bound to intranet.soclab.local
- Browser on WS01 loading http://intranet.soclab.local showing the portal page

## 2.10 — Unconstrained Delegation (DC01)
- `Get-ADComputer SRV01 -Properties TrustedForDelegation` showing True

## 2.11 — ADCS Installed
- Certificate Authority MMC showing SOCLab-CA as Enterprise Root CA
- `certutil -ca.cert` output

## 2.12 — ESC1 Vulnerable Template
- Certificate Templates console showing ESC1-VulnTemplate
- Template properties showing "Supply in the request" selected on Subject Name tab
- Domain Users having Enroll permission on Security tab
