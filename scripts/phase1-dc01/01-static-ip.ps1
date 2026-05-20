# Phase 1 - Step 1.3
# Run on DC01 immediately after OS install and rename
# Sets static IP, subnet, gateway, and DNS (loopback - DC will serve DNS for itself)

$ifIndex = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).ifIndex

New-NetIPAddress `
    -InterfaceIndex $ifIndex `
    -IPAddress 192.168.0.10 `
    -PrefixLength 24 `
    -DefaultGateway 192.168.0.1

Set-DnsClientServerAddress `
    -InterfaceIndex $ifIndex `
    -ServerAddresses 127.0.0.1

Write-Host "Static IP set. Verify with: ipconfig /all" -ForegroundColor Green
