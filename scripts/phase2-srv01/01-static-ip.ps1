# Phase 2 - Step 2.1
# Run on SRV01 immediately after OS install and rename
# Sets static IP pointing DNS at DC01

$ifIndex = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).ifIndex

New-NetIPAddress `
    -InterfaceIndex $ifIndex `
    -IPAddress 192.168.0.20 `
    -PrefixLength 24 `
    -DefaultGateway 192.168.0.1

Set-DnsClientServerAddress `
    -InterfaceIndex $ifIndex `
    -ServerAddresses 192.168.0.10

Write-Host "Static IP set. DNS pointing at DC01 (192.168.0.10)." -ForegroundColor Green
Write-Host "Verify with: ipconfig /all" -ForegroundColor Green
