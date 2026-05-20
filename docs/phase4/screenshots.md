# Phase 4 — GPO Screenshots

---

## 4.1 — All GPOs Created and Linked
- Group Policy Management showing all 5 GPOs linked to soclab.local

## 4.2 — Lab-Audit-Policy
- GPO Editor showing Advanced Audit Policy with Success+Failure on all categories

## 4.3 — Lab-Firewall-Policy
- GPO Editor showing Windows Defender Firewall enabled for Domain/Private/Public profiles
- Inbound rules showing RDP (3389) and WinRM (5985) restricted to 192.168.0.10
- Logging settings enabled

## 4.4 — Lab-Drive-Mapping
- GPO Editor showing Drive Maps preference (Z: → \\SRV01\Data)
- Item-level targeting showing Data-ReadWrite group filter
- WS01 logged in as jsmith showing Z: drive mapped in Explorer

## 4.5 — Lab-Screensaver-Policy
- GPO Editor showing screensaver timeout 600s, password protected enabled

## 4.6 — Lab-Security-Baseline
- GPO Editor showing Security Options configured

## 4.7 — Helpdesk Delegation
- ADUC showing Delegate Control wizard completed for OU=HR
- ADUC showing Delegate Control wizard completed for OU=Finance
- Test: logged in as helpdesk1, successfully reset jsmith password
- Test: helpdesk1 attempting to reset itadmin password — Access Denied
