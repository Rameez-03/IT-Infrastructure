# Phase 6 — Verification Screenshots

---

## 6.1 — AD Health
- `dcdiag /test:all` output on DC01 — all tests passing
- `repadmin /replsummary` — no replication errors

## 6.2 — DNS Resolution from WS01
- `Resolve-DnsName srv01.soclab.local` returning 192.168.0.20
- `Resolve-DnsName intranet.soclab.local` returning 192.168.0.20

## 6.3 — All Wazuh Agents Active
- Wazuh dashboard agents list showing DC01, SRV01, WS01 all Active simultaneously

## 6.4 — Share Access Test (from WS01)
- jsmith accessing \\SRV01\Data — success
- jsmith accessing \\SRV01\HR — success
- jsmith attempting \\SRV01\Finance — Access Denied
- awhite accessing \\SRV01\Finance — success
- awhite attempting \\SRV01\HR — Access Denied

## 6.5 — Misconfig Verification
- `setspn -L svc_backup` showing SPN entries
- `Get-ADUser svc_scan -Properties DoesNotRequirePreAuth` showing True
- `Get-ADComputer SRV01 -Properties TrustedForDelegation` showing True

## 6.6 — BloodHound Attack Path
- SharpHound collection running from WS01
- BloodHound showing jsmith → WriteDACL → HR-Users → GenericAll → svc_backup → DCSync path

## 6.7 — IIS Verified
- Browser on WS01 loading http://intranet.soclab.local

## 6.8 — ADCS Verified
- `certutil -ca.cert` output
- ESC1-VulnTemplate visible in Certificate Templates
