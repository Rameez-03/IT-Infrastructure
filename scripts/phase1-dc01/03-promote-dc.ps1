# Phase 1 - Step 1.5
# Run on DC01 after Wazuh agent is confirmed Active
# Installs AD DS role and promotes to Domain Controller
# VM will reboot automatically after promotion

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName "soclab.local" `
    -DomainNetbiosName "SOCLAB" `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -Force:$true

# You will be prompted for a SafeModeAdministratorPassword (DSRM password)
# Set it, note it down, then the VM reboots automatically
