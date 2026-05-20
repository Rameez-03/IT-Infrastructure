# Phase 3 - Steps 3.1 and 3.2
# Run on WS01 (Windows 10) before domain join
# Sets DNS to DC01, local admin password, then joins the domain

# --- Set DNS to DC01 ---
Write-Host "Setting DNS to DC01..." -ForegroundColor Cyan
$ifIndex = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).ifIndex
Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses 192.168.0.10

# --- Set local admin password (same on all machines - no LAPS) ---
Write-Host "Setting local administrator password..." -ForegroundColor Cyan
net user administrator LocalAdmin2024!

# --- Domain Join ---
# Will prompt for credentials - use itadmin
Write-Host "Joining domain soclab.local..." -ForegroundColor Cyan
Add-Computer -DomainName "soclab.local" -Credential (Get-Credential) -Restart
# VM reboots automatically
