# Phase 2 - Steps 2.9 and 2.10
# Run on SRV01 after roles are installed
# Configures IIS intranet site and installs ADCS as Enterprise Root CA

# --- IIS: Intranet Site ---
Write-Host "Configuring IIS intranet site..." -ForegroundColor Cyan
Import-Module WebAdministration

New-Item -ItemType Directory -Path "C:\inetpub\intranet" -Force

New-Website -Name "Intranet" -Port 80 -HostHeader "intranet.soclab.local" `
    -PhysicalPath "C:\inetpub\intranet" -Force

@"
<!DOCTYPE html>
<html>
<head><title>SOCLab Intranet</title></head>
<body>
<h1>SOCLab Internal Portal</h1>
<p>Welcome to the SOCLab corporate intranet.</p>
<ul>
  <li><a href="\\SRV01\Data">Shared Drive (Data)</a></li>
  <li><a href="\\SRV01\HR">HR Documents</a></li>
  <li><a href="\\SRV01\Finance">Finance Reports</a></li>
</ul>
</body>
</html>
"@ | Out-File "C:\inetpub\intranet\index.html" -Encoding utf8

# Set svc_iis as app pool identity (SeImpersonatePrivilege - Potato attack surface)
Set-ItemProperty "IIS:\AppPools\DefaultAppPool" -Name processModel `
    -Value @{userName="SOCLAB\svc_iis"; password="IIS2024!"; identitytype=3}

Write-Host "IIS intranet site configured." -ForegroundColor Green

# --- ADCS: Enterprise Root CA ---
Write-Host "Installing ADCS as Enterprise Root CA..." -ForegroundColor Cyan
Install-AdcsCertificationAuthority `
    -CAType EnterpriseRootCa `
    -CaCommonName "SOCLab-CA" `
    -CaDistinguishedNameSuffix "DC=soclab,DC=local" `
    -KeyLength 2048 `
    -HashAlgorithmName SHA256 `
    -ValidityPeriod Years `
    -ValidityPeriodUnits 10 `
    -Force

Write-Host "ADCS installed. Now create ESC1 vulnerable template manually via Certificate Authority MMC." -ForegroundColor Yellow
Write-Host ""
Write-Host "ESC1 template steps:"
Write-Host "  1. Open certsrv.msc > Certificate Templates > Manage"
Write-Host "  2. Duplicate 'User' template > name it ESC1-VulnTemplate"
Write-Host "  3. Subject Name tab: Select 'Supply in the request'"
Write-Host "  4. Extensions tab: Application Policies > add Client Authentication"
Write-Host "  5. Security tab: Allow 'Domain Users' to Enroll"
Write-Host "  6. Back in CA > Certificate Templates > New > Certificate Template to Issue > select ESC1-VulnTemplate"
