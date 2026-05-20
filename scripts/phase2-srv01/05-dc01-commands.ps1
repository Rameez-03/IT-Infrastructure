# Phase 2 - Steps 2.4 (move to OU), 2.9 (DNS), 2.8 (unconstrained delegation)
# Run on DC01 after SRV01 has joined the domain
# These commands must run on DC01, not SRV01

# Move SRV01 to Servers OU
Write-Host "Moving SRV01 to Servers OU..." -ForegroundColor Cyan
Get-ADComputer SRV01 | Move-ADObject -TargetPath "OU=Servers,DC=soclab,DC=local"

# Add DNS A record for intranet site
Write-Host "Adding DNS record for intranet.soclab.local..." -ForegroundColor Cyan
Add-DnsServerResourceRecordA -ZoneName "soclab.local" -Name "intranet" -IPv4Address "192.168.0.20"

# Enable Unconstrained Delegation on SRV01 machine account (intentional)
Write-Host "Enabling unconstrained delegation on SRV01 (intentional)..." -ForegroundColor Cyan
Set-ADComputer SRV01 -TrustedForDelegation $true

Write-Host "DC01-side SRV01 configuration complete." -ForegroundColor Green
