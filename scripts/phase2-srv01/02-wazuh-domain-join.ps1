# Phase 2 - Steps 2.2 and 2.3
# Run on SRV01 after static IP is set
# Installs Wazuh agent then domain joins

# --- Wazuh Agent ---
# Get exact MSI URL from Wazuh dashboard: Agents > Deploy new agent > Windows
$wazuhUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.x.x-1.msi"  # Replace with URL from dashboard
$outFile   = "$env:TEMP\wazuh-agent.msi"

Write-Host "Downloading Wazuh agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $wazuhUrl -OutFile $outFile

Write-Host "Installing Wazuh agent..." -ForegroundColor Cyan
msiexec /i $outFile WAZUH_MANAGER="192.168.0.61" WAZUH_AGENT_NAME="SRV01" /q

net start WazuhSvc
Write-Host "Wazuh agent installed. Verify SRV01 shows Active in dashboard." -ForegroundColor Green

# --- Domain Join ---
# Will prompt for credentials - use itadmin
Write-Host "Joining domain soclab.local..." -ForegroundColor Cyan
Add-Computer -DomainName "soclab.local" -Credential (Get-Credential) -Restart
# VM reboots automatically
