# Phase 1 - Steps 1.10, 1.11, 1.12
# Run on DC01 after users and groups are created
# Configures intentional misconfigurations for attack simulation

# --- Kerberoasting: SPN on svc_backup ---
Write-Host "Setting SPN on svc_backup (Kerberoasting target)..." -ForegroundColor Cyan
setspn -A backup/dc01.soclab.local svc_backup
setspn -A backup/dc01 svc_backup

Write-Host "Verifying SPN..." -ForegroundColor Cyan
setspn -L svc_backup

# --- AS-REP Roasting: disable pre-auth on svc_scan ---
Write-Host "Disabling Kerberos pre-auth on svc_scan (AS-REP Roasting target)..." -ForegroundColor Cyan
Set-ADAccountControl -Identity svc_scan -DoesNotRequirePreAuth $true

Write-Host "Verifying pre-auth disabled..." -ForegroundColor Cyan
Get-ADUser svc_scan -Properties DoesNotRequirePreAuth | Select-Object SamAccountName, DoesNotRequirePreAuth

# --- Weak Password Policy (intentional) ---
Write-Host "Applying weak domain password policy (intentional)..." -ForegroundColor Cyan
Set-ADDefaultDomainPasswordPolicy -Identity soclab.local `
    -MinPasswordLength 7 `
    -ComplexityEnabled $false `
    -LockoutThreshold 0 `
    -MaxPasswordAge (New-TimeSpan -Days 365)

# --- Print Spooler: verify running (do NOT stop it) ---
Write-Host "Verifying Print Spooler is running (NTLM coercion surface - leave running)..." -ForegroundColor Cyan
Get-Service Spooler

Write-Host "Misconfigs applied." -ForegroundColor Green
