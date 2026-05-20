# Phase 5 — Sysmon Screenshots

---

## 5.1 — Sysmon Installed on DC01
- PowerShell output of Sysmon64.exe install completing on DC01
- Event Viewer → Applications and Services Logs → Microsoft → Windows → Sysmon → Operational showing events

## 5.2 — Sysmon Installed on SRV01
- Same as above on SRV01

## 5.3 — Sysmon Installed on WS01
- Same as above on WS01

## 5.4 — Wazuh ossec.conf Updated
- ossec.conf on one machine showing the Sysmon/Operational localfile block added

## 5.5 — Sysmon Events in Wazuh
- Wazuh dashboard → Events showing Sysmon event IDs (e.g. Event ID 1 process creation) from each agent
