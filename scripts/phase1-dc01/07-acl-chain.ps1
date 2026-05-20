# Phase 1 - Step 1.15
# Run on DC01 after users and groups are created
# Sets up the BloodHound attack path:
#   jsmith -[WriteDACL]-> HR-Users -[GenericAll]-> svc_backup -[DCSync]-> Domain

Write-Host "Setting ACL abuse chain..." -ForegroundColor Cyan

# 1. jsmith gets WriteDACL on HR-Users group
$hrGroup  = Get-ADGroup "HR-Users"
$jsmithSid = (Get-ADUser jsmith).SID
$acl = Get-Acl "AD:$($hrGroup.DistinguishedName)"
$ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $jsmithSid,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteDacl,
    [System.Security.AccessControl.AccessControlType]::Allow
)
$acl.AddAccessRule($ace)
Set-Acl -Path "AD:$($hrGroup.DistinguishedName)" -AclObject $acl
Write-Host "  [1/3] jsmith WriteDACL on HR-Users - done" -ForegroundColor Yellow

# 2. HR-Users gets GenericAll on svc_backup
$hrSid  = (Get-ADGroup "HR-Users").SID
$acl2   = Get-Acl "AD:$((Get-ADUser svc_backup).DistinguishedName)"
$ace2   = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $hrSid,
    [System.DirectoryServices.ActiveDirectoryRights]::GenericAll,
    [System.Security.AccessControl.AccessControlType]::Allow
)
$acl2.AddAccessRule($ace2)
Set-Acl -Path "AD:$((Get-ADUser svc_backup).DistinguishedName)" -AclObject $acl2
Write-Host "  [2/3] HR-Users GenericAll on svc_backup - done" -ForegroundColor Yellow

# 3. svc_backup gets DCSync rights (DS-Replication-Get-Changes-All)
$svcSid             = (Get-ADUser svc_backup).SID
$rootDSE            = [ADSI]"LDAP://RootDSE"
$defaultNamingContext = $rootDSE.defaultNamingContext
$acl3               = Get-Acl "AD:$defaultNamingContext"
$replicationGuid    = [GUID]"1131f6ad-9c07-11d1-f79f-00c04fc2dcd2"
$ace3               = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $svcSid,
    [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $replicationGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)
$acl3.AddAccessRule($ace3)
Set-Acl -Path "AD:$defaultNamingContext" -AclObject $acl3
Write-Host "  [3/3] svc_backup DCSync rights - done" -ForegroundColor Yellow

Write-Host "ACL chain complete. Verify with BloodHound after WS01 is joined." -ForegroundColor Green
