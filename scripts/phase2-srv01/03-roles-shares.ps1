# Phase 2 - Steps 2.4, 2.5, 2.6, 2.7, 2.8
# Run on SRV01 after domain join and reboot
# Installs server roles, creates file shares, and applies misconfigs

# --- Install Roles ---
Write-Host "Installing server roles..." -ForegroundColor Cyan
Install-WindowsFeature -Name `
    Web-Server, `
    Web-Mgmt-Tools, `
    FS-FileServer, `
    Print-Server, `
    ADCS-Cert-Authority, `
    RSAT-ADCS, `
    RSAT-ADCS-Mgmt `
    -IncludeManagementTools

# --- File Shares ---
Write-Host "Creating file shares..." -ForegroundColor Cyan
$shares = @("Data","HR","Finance","IT")
foreach ($s in $shares) {
    New-Item -ItemType Directory -Path "C:\Shares\$s" -Force
}

New-SmbShare -Name "Data"    -Path "C:\Shares\Data"    -FullAccess "SOCLAB\Data-ReadWrite"
New-SmbShare -Name "HR"      -Path "C:\Shares\HR"      -FullAccess "SOCLAB\HR-Users"
New-SmbShare -Name "Finance" -Path "C:\Shares\Finance" -FullAccess "SOCLAB\Finance-Users"
New-SmbShare -Name "IT"      -Path "C:\Shares\IT"      -FullAccess "SOCLAB\IT-Admins"

# Fake credentials file in Data share (discovery simulation target)
@"
# System Credentials - DO NOT SHARE
Admin portal: admin / P@ssw0rd123
Backup system: backup_svc / Backup2024!
Database: db_admin / DBPass2024!
"@ | Out-File "C:\Shares\Data\credentials.txt" -Encoding utf8

Write-Host "Shares created with credentials.txt planted in Data share." -ForegroundColor Yellow

# --- Disable SMB Signing (intentional - NTLM relay target) ---
Write-Host "Disabling SMB signing (intentional)..." -ForegroundColor Cyan
Set-SmbServerConfiguration -RequireSecuritySignature $false -EnableSecuritySignature $false -Force

# --- Enable WinRM (lateral movement surface) ---
Write-Host "Enabling WinRM..." -ForegroundColor Cyan
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# --- Set local admin password (no LAPS - same on all machines) ---
Write-Host "Setting local administrator password..." -ForegroundColor Cyan
net user administrator LocalAdmin2024!

Write-Host "Roles, shares, and misconfigs complete." -ForegroundColor Green
