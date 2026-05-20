# Phase 1 - Step 1.6
# Run on DC01 after reboot following promotion
# Verifies DNS is working and pre-creates SRV01 A record

# Verify DC01 resolves itself
Resolve-DnsName dc01.soclab.local

# Pre-create A record for SRV01 (before SRV01 is built)
Add-DnsServerResourceRecordA -ZoneName "soclab.local" -Name "srv01" -IPv4Address "192.168.0.20"

# Verify
Resolve-DnsName srv01.soclab.local

Write-Host "DNS verified and SRV01 record created." -ForegroundColor Green
