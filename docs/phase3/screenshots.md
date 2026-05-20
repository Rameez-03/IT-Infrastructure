# Phase 3 — WS01 Screenshots

---

## 3.1 — DNS Set to DC01
- `ipconfig /all` on WS01 showing DNS: 192.168.0.10

## 3.2 — Domain Joined
- System Properties on WS01 showing domain: soclab.local
- ADUC on DC01 showing WS01 computer object in OU=Workstations

## 3.3 — jsmith Local Admin
- WS01 Local Users and Groups showing SOCLAB\jsmith in Administrators group

## 3.4 — SMB Signing Disabled
- `Get-SmbServerConfiguration` on WS01 showing RequireSecuritySignature: False

## 3.5 — WinRM Enabled
- `winrm enumerate winrm/config/listener` on WS01 showing listener active

## 3.6 — Wazuh Agent Active
- Wazuh dashboard showing WS01 as **Active**
- All 3 agents (DC01, SRV01, WS01) shown Active simultaneously
