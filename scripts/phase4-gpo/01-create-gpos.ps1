# Phase 4 - GPO Creation
# Run on DC01
# Creates and links all lab GPOs
# NOTE: Drive mapping preferences, wallpaper path, and firewall/audit rules
#       must be configured manually via Group Policy Management Editor (gpmc.msc)
#       See comments below each GPO for what to configure inside it

Import-Module GroupPolicy

$domain = "soclab.local"

# --- Lab-Audit-Policy ---
Write-Host "Creating Lab-Audit-Policy..." -ForegroundColor Cyan
New-GPO -Name "Lab-Audit-Policy" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Audit-Policy" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > Computer Config > Windows Settings > Security Settings > Advanced Audit Policy"
Write-Host "    Set Success+Failure on: Account Logon, Account Management, Directory Service Access,"
Write-Host "    Logon/Logoff, Object Access, Privilege Use, Policy Change, System"

# --- Lab-Firewall-Policy ---
Write-Host "Creating Lab-Firewall-Policy..." -ForegroundColor Cyan
New-GPO -Name "Lab-Firewall-Policy" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Firewall-Policy" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > Computer Config > Windows Settings > Security Settings > Windows Defender Firewall"
Write-Host "    Enable all profiles, allow RDP(3389) + WinRM(5985) from 192.168.0.10, block all other inbound"
Write-Host "    Enable logging: dropped packets + successful connections"

# --- Lab-Drive-Mapping ---
Write-Host "Creating Lab-Drive-Mapping..." -ForegroundColor Cyan
New-GPO -Name "Lab-Drive-Mapping" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Drive-Mapping" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > User Config > Preferences > Windows Settings > Drive Maps"
Write-Host "    Action: Create | Location: \\SRV01\Data | Drive: Z | Label: Shared Data"
Write-Host "    Item-level targeting: Security Group = Data-ReadWrite"

# --- Lab-Desktop-Background ---
Write-Host "Creating Lab-Desktop-Background..." -ForegroundColor Cyan
New-GPO -Name "Lab-Desktop-Background" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Desktop-Background" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > User Config > Policies > Admin Templates > Desktop > Desktop"
Write-Host "    Desktop Wallpaper: set path to image in SYSVOL | Style: Fill"

# --- Lab-Screensaver-Policy ---
Write-Host "Creating Lab-Screensaver-Policy..." -ForegroundColor Cyan
New-GPO -Name "Lab-Screensaver-Policy" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Screensaver-Policy" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > User Config > Policies > Admin Templates > Control Panel > Personalization"
Write-Host "    Enable screen saver: Enabled | Timeout: 600 seconds | Password protect: Enabled"

# --- Lab-Security-Baseline ---
Write-Host "Creating Lab-Security-Baseline..." -ForegroundColor Cyan
New-GPO -Name "Lab-Security-Baseline" -Domain $domain | Out-Null
New-GPLink -Name "Lab-Security-Baseline" -Target "DC=soclab,DC=local" | Out-Null
Write-Host "  > Linked to domain root" -ForegroundColor Yellow
Write-Host "  > MANUAL: Edit GPO > Computer Config > Windows Settings > Security Settings > Local Policies > Security Options"
Write-Host "    - Interactive logon: Display user information when locked = Do not display user information"
Write-Host "    - Network access: Do not allow anonymous enumeration of SAM accounts = Enabled"
Write-Host "    - NOTE: Do NOT set LM auth level to 5 - leave default for NTLMv1 attack surface"

Write-Host ""
Write-Host "All GPOs created and linked. Complete manual steps in gpmc.msc." -ForegroundColor Green
