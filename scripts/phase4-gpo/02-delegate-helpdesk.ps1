# Phase 4 - Helpdesk Delegation
# Run on DC01
# Delegation of password reset to helpdesk1 on HR and Finance OUs
# This is a GUI task in ADUC - script below is a reminder of what to do

Write-Host "Helpdesk delegation is a GUI task." -ForegroundColor Yellow
Write-Host ""
Write-Host "Steps in Active Directory Users and Computers (dsa.msc):"
Write-Host "  1. Right-click OU=HR > Delegate Control"
Write-Host "  2. Add: helpdesk1"
Write-Host "  3. Task: 'Reset user passwords and force password change at next logon'"
Write-Host "  4. Finish"
Write-Host ""
Write-Host "  Repeat the above for OU=Finance"
Write-Host ""
Write-Host "Verify delegation boundary:"
Write-Host "  - helpdesk1 CAN reset jsmith and awhite passwords"
Write-Host "  - helpdesk1 CANNOT reset itadmin password"
