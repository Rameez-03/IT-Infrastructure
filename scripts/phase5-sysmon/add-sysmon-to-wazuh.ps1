# Phase 5 - Wire Sysmon into Wazuh
# Run on DC01, SRV01, and WS01 after Sysmon is installed
# Adds the Sysmon event channel to ossec.conf and restarts the Wazuh agent

$wazuhConfig = "C:\Program Files (x86)\ossec-agent\ossec.conf"

# Read current config
$content = Get-Content $wazuhConfig -Raw

# The block to inject - add Sysmon Operational log channel
$sysmonBlock = @"

  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
"@

# Insert before closing </ossec_config> tag
if ($content -notmatch "Sysmon/Operational") {
    $content = $content -replace "</ossec_config>", "$sysmonBlock`n</ossec_config>"
    Set-Content -Path $wazuhConfig -Value $content -Encoding UTF8
    Write-Host "Sysmon log channel added to ossec.conf" -ForegroundColor Green
} else {
    Write-Host "Sysmon channel already present in ossec.conf" -ForegroundColor Yellow
}

# Restart Wazuh agent to apply
Write-Host "Restarting Wazuh agent..." -ForegroundColor Cyan
Restart-Service -Name WazuhSvc

Write-Host "Done. Verify Sysmon events appear in Wazuh dashboard for this agent." -ForegroundColor Green
