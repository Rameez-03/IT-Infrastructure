# Phase 3 - Steps 3.4, 3.5
# Run on WS01 after domain join and reboot
# Disables SMB signing and enables WinRM

# --- Disable SMB Signing (intentional - NTLM relay target) ---
Write-Host "Disabling SMB signing on WS01 (intentional)..." -ForegroundColor Cyan
Set-SmbServerConfiguration -RequireSecuritySignature $false -EnableSecuritySignature $false -Force

# --- Enable WinRM (lateral movement surface) ---
Write-Host "Enabling WinRM on WS01..." -ForegroundColor Cyan
Enable-PSRemoting -Force

Write-Host "WS01 post-join configuration complete." -ForegroundColor Green
Write-Host "Remember to verify/reconfigure Wazuh agent points to 192.168.0.61" -ForegroundColor Yellow
