# Phase 1 - Steps 1.7, 1.8, 1.9
# Run on DC01 after DNS is verified
# Creates all OUs, user accounts, and security groups

$base = "DC=soclab,DC=local"

# --- Organisational Units ---
Write-Host "Creating OUs..." -ForegroundColor Cyan
foreach ($ou in @("IT","HR","Finance","Servers","Workstations","ServiceAccounts","Disabled")) {
    New-ADOrganizationalUnit -Name $ou -Path $base
}

# --- Users ---
Write-Host "Creating users..." -ForegroundColor Cyan
$pw = { ConvertTo-SecureString $args[0] -AsPlainText -Force }

New-ADUser -Name "IT Admin" -SamAccountName itadmin -UserPrincipalName itadmin@soclab.local `
    -Path "OU=IT,$base" -AccountPassword (& $pw "ITAdmin2024!") -Enabled $true
Add-ADGroupMember -Identity "Domain Admins" -Members itadmin

New-ADUser -Name "Help Desk" -SamAccountName helpdesk1 -UserPrincipalName helpdesk1@soclab.local `
    -Path "OU=IT,$base" -AccountPassword (& $pw "Helpdesk1!") -Enabled $true

New-ADUser -Name "John Smith" -SamAccountName jsmith -UserPrincipalName jsmith@soclab.local `
    -Path "OU=HR,$base" -AccountPassword (& $pw "Welcome1!") -Enabled $true

New-ADUser -Name "Alice White" -SamAccountName awhite -UserPrincipalName awhite@soclab.local `
    -Path "OU=Finance,$base" -AccountPassword (& $pw "Welcome1!") -Enabled $true

New-ADUser -Name "Bob Jones" -SamAccountName bjones -UserPrincipalName bjones@soclab.local `
    -Path "OU=HR,$base" -AccountPassword (& $pw "Welcome1!") -Enabled $true

New-ADUser -Name "svc_backup" -SamAccountName svc_backup -UserPrincipalName svc_backup@soclab.local `
    -Path "OU=ServiceAccounts,$base" -AccountPassword (& $pw "Backup2024!") `
    -Enabled $true -PasswordNeverExpires $true

New-ADUser -Name "svc_scan" -SamAccountName svc_scan -UserPrincipalName svc_scan@soclab.local `
    -Path "OU=ServiceAccounts,$base" -AccountPassword (& $pw "Scan2024!") `
    -Enabled $true -PasswordNeverExpires $true

New-ADUser -Name "svc_iis" -SamAccountName svc_iis -UserPrincipalName svc_iis@soclab.local `
    -Path "OU=ServiceAccounts,$base" -AccountPassword (& $pw "IIS2024!") `
    -Enabled $true -PasswordNeverExpires $true

# --- Groups ---
Write-Host "Creating groups..." -ForegroundColor Cyan
New-ADGroup -Name "IT-Admins"           -GroupScope Global -Path "OU=IT,$base"
New-ADGroup -Name "Help-Desk"           -GroupScope Global -Path "OU=IT,$base"
New-ADGroup -Name "Finance-Users"       -GroupScope Global -Path "OU=Finance,$base"
New-ADGroup -Name "HR-Users"            -GroupScope Global -Path "OU=HR,$base"
New-ADGroup -Name "Data-ReadWrite"      -GroupScope Global -Path $base
New-ADGroup -Name "Backup-Operators-Lab" -GroupScope Global -Path "OU=ServiceAccounts,$base"

# --- Group Memberships ---
Write-Host "Assigning group memberships..." -ForegroundColor Cyan
Add-ADGroupMember -Identity "IT-Admins"            -Members itadmin
Add-ADGroupMember -Identity "Help-Desk"            -Members helpdesk1
Add-ADGroupMember -Identity "Finance-Users"        -Members awhite
Add-ADGroupMember -Identity "HR-Users"             -Members jsmith, bjones
Add-ADGroupMember -Identity "Data-ReadWrite"       -Members jsmith, awhite, bjones
Add-ADGroupMember -Identity "Backup-Operators-Lab" -Members svc_backup

Write-Host "OUs, users, and groups created." -ForegroundColor Green
