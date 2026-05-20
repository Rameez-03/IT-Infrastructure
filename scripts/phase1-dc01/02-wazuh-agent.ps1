# Phase 1 - Step 1.4
# Run on DC01 BEFORE domain promotion
# Install Wazuh agent pointing at SIEM on 192.168.0.61
# Get the exact MSI URL from your Wazuh dashboard: Agents > Deploy new agent > Windows

$wazuhUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.x.x-1.msi"  # Replace with URL from dashboard
$outFile   = "$env:TEMP\wazuh-agent.msi"

Write-Host "Downloading Wazuh agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $wazuhUrl -OutFile $outFile

Write-Host "Installing Wazuh agent..." -ForegroundColor Cyan
msiexec /i $outFile WAZUH_MANAGER="192.168.0.61" WAZUH_AGENT_NAME="DC01" /q

Write-Host "Starting Wazuh service..." -ForegroundColor Cyan
net start WazuhSvc

Write-Host "Done. Verify DC01 shows as Active in the Wazuh dashboard before continuing." -ForegroundColor Green
