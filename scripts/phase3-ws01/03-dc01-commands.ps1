# Phase 3 - Steps 3.3 (post-join tasks)
# Run on DC01 after WS01 has joined the domain

# Move WS01 to Workstations OU
Write-Host "Moving WS01 to Workstations OU..." -ForegroundColor Cyan
Get-ADComputer WS01 | Move-ADObject -TargetPath "OU=Workstations,DC=soclab,DC=local"

# Make jsmith a local admin on WS01 only
Write-Host "Adding jsmith as local admin on WS01..." -ForegroundColor Cyan
Invoke-Command -ComputerName WS01 -ScriptBlock {
    Add-LocalGroupMember -Group "Administrators" -Member "SOCLAB\jsmith"
}

Write-Host "DC01-side WS01 configuration complete." -ForegroundColor Green
