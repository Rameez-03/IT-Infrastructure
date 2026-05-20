# Phase 6 - Full Environment Verification
# Run on DC01 after all phases are complete
# Works through every item in the verification checklist

Write-Host "======================================" -ForegroundColor Magenta
Write-Host " SOCLab Verification Checklist" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta

# --- AD Health ---
Write-Host "`n[AD HEALTH]" -ForegroundColor Cyan
Write-Host "Running dcdiag (this may take a minute)..."
dcdiag /test:all

Write-Host "`nChecking replication..."
repadmin /replsummary

Write-Host "`nDNS resolution check from DC01..."
Resolve-DnsName dc01.soclab.local
Resolve-DnsName srv01.soclab.local
Resolve-DnsName intranet.soclab.local

# --- User accounts exist ---
Write-Host "`n[USER ACCOUNTS]" -ForegroundColor Cyan
$users = @("itadmin","helpdesk1","jsmith","awhite","bjones","svc_backup","svc_scan","svc_iis")
foreach ($u in $users) {
    $exists = Get-ADUser -Filter { SamAccountName -eq $u } -ErrorAction SilentlyContinue
    if ($exists) {
        Write-Host "  [PASS] $u exists" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $u NOT FOUND" -ForegroundColor Red
    }
}

# --- Wazuh Agents (check via Wazuh API or dashboard manually) ---
Write-Host "`n[WAZUH AGENTS]" -ForegroundColor Cyan
Write-Host "  Manually verify in Wazuh dashboard (192.168.0.61):"
Write-Host "  [ ] DC01 agent - Active"
Write-Host "  [ ] SRV01 agent - Active"
Write-Host "  [ ] WS01 agent - Active"

# --- Misconfigs ---
Write-Host "`n[MISCONFIGS]" -ForegroundColor Cyan

Write-Host "`nKerberoasting - SPN on svc_backup:"
setspn -L svc_backup

Write-Host "`nAS-REP Roasting - pre-auth disabled on svc_scan:"
Get-ADUser svc_scan -Properties DoesNotRequirePreAuth | Select-Object SamAccountName, DoesNotRequirePreAuth

Write-Host "`nUnconstrained delegation on SRV01:"
Get-ADComputer SRV01 -Properties TrustedForDelegation | Select-Object Name, TrustedForDelegation

Write-Host "`nWeak password policy:"
Get-ADDefaultDomainPasswordPolicy | Select-Object MinPasswordLength, ComplexityEnabled, LockoutThreshold

# --- Computer accounts in correct OUs ---
Write-Host "`n[COMPUTER OUs]" -ForegroundColor Cyan
Get-ADComputer DC01  | Select-Object Name, DistinguishedName
Get-ADComputer SRV01 | Select-Object Name, DistinguishedName
Get-ADComputer WS01  | Select-Object Name, DistinguishedName

# --- ADCS ---
Write-Host "`n[ADCS]" -ForegroundColor Cyan
certutil -ca.cert | Select-Object -First 5
Write-Host "  Manually verify ESC1-VulnTemplate visible in Certificate Templates MMC"

# --- Shares (run from WS01 as jsmith / awhite to verify access) ---
Write-Host "`n[FILE SHARES]" -ForegroundColor Cyan
Write-Host "  Manually verify from WS01:"
Write-Host "  [ ] \\SRV01\Data    - accessible as jsmith (Data-ReadWrite member)"
Write-Host "  [ ] \\SRV01\HR      - accessible as jsmith, NOT as awhite"
Write-Host "  [ ] \\SRV01\Finance - accessible as awhite, NOT as jsmith"

# --- IIS ---
Write-Host "`n[IIS]" -ForegroundColor Cyan
Write-Host "  Manually verify from WS01 browser: http://intranet.soclab.local"

Write-Host "`n======================================" -ForegroundColor Magenta
Write-Host " Verification complete. Review output above." -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta
