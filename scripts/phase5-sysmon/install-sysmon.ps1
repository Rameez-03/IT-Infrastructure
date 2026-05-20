# Phase 5 - Sysmon Deployment
# Run on DC01, SRV01, and WS01 (run on each separately)
# Installs Sysmon with SwiftOnSecurity config and wires it into Wazuh

$sysmonUrl    = "https://download.sysinternals.com/files/Sysmon.zip"
$configUrl    = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$workDir      = "$env:TEMP\sysmon-install"

New-Item -ItemType Directory -Path $workDir -Force | Out-Null

# Download Sysmon
Write-Host "Downloading Sysmon..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $sysmonUrl -OutFile "$workDir\Sysmon.zip"
Expand-Archive "$workDir\Sysmon.zip" -DestinationPath $workDir -Force

# Download SwiftOnSecurity config
Write-Host "Downloading SwiftOnSecurity sysmon config..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $configUrl -OutFile "$workDir\sysmonconfig.xml"

# Install Sysmon
Write-Host "Installing Sysmon..." -ForegroundColor Cyan
& "$workDir\Sysmon64.exe" -accepteula -i "$workDir\sysmonconfig.xml"

Write-Host "Sysmon installed. Now add Sysmon log channel to Wazuh agent config." -ForegroundColor Green
Write-Host "See add-sysmon-to-wazuh.ps1 for next step." -ForegroundColor Yellow
