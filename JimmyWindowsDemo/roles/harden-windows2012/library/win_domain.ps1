#!powershell
# (c)2016, Matt Davis<mdavis@ansible.com>

# WANT_JSON
# POWERSHELL_COMMON

$ErrorActionPreference = "Stop"

$parsed_args = Parse-Args $args -supports_check_mode $true
$check_mode = Get-AnsibleParam $parsed_args "_ansible_check_mode" -default $false
$forest_root_dns_domain = Get-AnsibleParam $parsed_args "forest_root_dns_domain" -failifempty $true
$safe_mode_admin_password = Get-AnsibleParam $parsed_args "safe_mode_admin_password" -failifempty $true

$f = $null

If([System.Environment]::OSVersion.Version -lt [Version]"6.3.9600.0") {
    Fail-Json "win_domain requires Windows Server 2012R2 or higher"
}

$result = @{changed=$false; actions=[System.Collections.ArrayList]@(); reboot_required=$false}

Function Ensure-Prereqs {
    $gwf = Get-WindowsFeature AD-Domain-Services
    If($gwf.InstallState -ne "Installed") {
        $result.changed = $true
        $result.actions.Add("installed AD-DomainServices Windows Feature")
        If($check_mode) {
            # FUTURE: just return so we can collect all actions?
            Exit-Json $result
        }
        $awf = Add-WindowsFeature AD-Domain-Services
        # FUTURE: check if reboot necessary
    }
}

Ensure-Prereqs

Try {
    $f = Get-ADForest $forest_root_dns_domain -ErrorAction SilentlyContinue
}
Catch { }

If(-not $f) {
    $result.changed = $true
    If(-not $check_mode) {
        $result.actions.Add("created forest $forest_root_dns_domain")
    }

    $sm_cred = ConvertTo-SecureString $safe_mode_admin_password -AsPlainText -Force

    $install_forest_args = @{
        DomainName=$forest_root_dns_domain;
        SafeModeAdministratorPassword=$sm_cred;
        Confirm=$false;
        SkipPreChecks=$true;
        InstallDNS=$true;
        NoRebootOnCompletion=$true;
    }

    $iaf = Install-ADDSForest @install_forest_args

    $result.reboot_required = $iaf.RebootRequired
}

Exit-Json $result
