# Get all servers in the domain
get-adcomputer -filter * | ForEach-Object {
    Write-Host $_.Name

    # Allow unsigned scripts to run in PowerShell
    Invoke-command -computername $_.Name -scriptblock {Set-ExecutionPolicy RemoteSigned}

    # Download and execute PS3 upgrade script
    Invoke-command -computername $_.Name -scriptblock {Invoke-WebRequest -Uri https://raw.githubusercontent.com/cchurch/ansible/devel/examples/scripts/upgrade_to_ps3.ps1 -OutFile C:\Users\Administrator\Desktop\upgrade_to_ps3.ps1}
    Invoke-command -computername $_.Name -scriptblock {C:\Users\Administrator\Desktop\upgrade_to_ps3.ps1}

    # Download and execute WinRM configuration script
    Invoke-command -computername $_.Name -scriptblock {Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile C:\Users\Administrator\Desktop\ConfigureRemotingForAnsible.ps1}
    Invoke-command -computername $_.Name -scriptblock {C:\Users\Administrator\Desktop\ConfigureRemotingForAnsible.ps1}
}