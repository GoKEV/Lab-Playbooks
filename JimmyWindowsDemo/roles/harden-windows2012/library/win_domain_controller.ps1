#!powershell

# (c) 2015, Matt Davis <mdavis@ansible.com>

# WANT_JSON
# POWERSHELL_COMMON

Set-StrictMode -Version 2

$ErrorActionPreference = "Stop"
$ConfirmPreference = "None"

$log_path = $null

Function Write-DebugLog {
    Param(
        [string]$msg
    )

    $DebugPreference = "Continue"
    $ErrorActionPreference = "Continue"
    $date_str = Get-Date -Format u
    $msg = "$date_str $msg"

    Write-Debug $msg

    if($log_path) {
        Add-Content $log_path $msg
    }
}

$required_features = @("AD-Domain-Services","RSAT-ADDS")

Function Get-MissingFeatures {
    Write-DebugLog "Checking for missing Windows features..."

    $features = @(Get-WindowsFeature $required_features)

    If($features.Count -ne $required_features.Count) {
        Throw "One or more Windows features required for a domain controller are unavailable"
    }

    $missing_features = @($features | Where-Object InstallState -ne Installed)
    
    return ,$missing_features # no, the comma's not a typo- allows us to return an empty array
}

Function Ensure-FeatureInstallation {
    # ensure RSAT-ADDS and AD-Domain-Services features are installed

    Write-DebugLog "Ensuring required Windows features are installed..." 
    $feature_result = Install-WindowsFeature $required_features

    If(-not $feature_result.Success) {
        Throw ("Error installing AD-Domain-Services and RSAT-ADDS features: {0}" -f ($feature_result | Out-String))
    }
}

# return the domain we're a DC for, or null if not a DC
Function Get-DomainControllerDomain {
    Write-DebugLog "Checking for domain controller role and domain name"

    $sys_cim = Get-WmiObject Win32_ComputerSystem

    $is_dc = $sys_cim.DomainRole -in (4,5) # backup/primary DC
    # this will be our workgroup or joined-domain if we're not a DC
    $domain = $sys_cim.Domain

    Switch($is_dc) {
        $true { return $domain }
        Default { return $null }
    }
}

Function Create-Credential {
    Param(
        [string] $cred_user,
        [string] $cred_pass
    )

    $cred = New-Object System.Management.Automation.PSCredential($cred_user, $($cred_pass | ConvertTo-SecureString -AsPlainText -Force))

    Return $cred
}

Function Get-OperationMasterRoles {
    $assigned_roles = @((Get-ADDomainController -Server localhost).OperationMasterRoles)

    Return ,$assigned_roles # no, the comma's not a typo- allows us to return an empty array
}

Function Module-Impl {
    Param(
        [string] $dns_domain_name,
        [string] $safe_mode_pass,
        [string] $domain_admin_user=$(throw "domain_admin_user is required"),
        [string] $domain_admin_pass=$(throw "domain_admin_pass is required"),
        [string] $local_admin_pass,
        [ValidateSet("domain_controller", "member_server")]
        [string] $state=$(throw "state is required"),
        [string] $log_path,
        [bool] $_ansible_check_mode=$false # default to false since old versions of Ansible won't pass it
    )

    $global:log_path = $log_path

    Try {

        $result = @{
            changed = $false
            reboot_required = $false
        }

        # ensure that domain admin user is in UPN or down-level domain format (prevent hang from https://support.microsoft.com/en-us/kb/2737935)

        If(-not $domain_admin_user.Contains("\") -and -not $domain_admin_user.Contains("@")) {
            throw "domain_admin_user must be in domain\user or user@domain.com format"
        }
    	
        # TODO: validate args

        # short-circuit "member server" check, since we don't need feature checks for this...

        $current_dc_domain = Get-DomainControllerDomain

        If($state -eq "member_server" -and -not $current_dc_domain) {
            Return $result
        }

        # all other operations will require the AD-DS and RSAT-ADDS features...

        $missing_features = Get-MissingFeatures

        If($missing_features.Count -gt 0) {
            Write-DebugLog ("Missing Windows features ({0}), need to install" -f ($missing_features -join ", "))
            $result.changed = $true # we need to install features
            If($_ansible_check_mode) {
                # bail out here- we can't proceed without knowing the features are installed
                Write-DebugLog "check-mode, exiting early"
                Return $result
            }

            Ensure-FeatureInstallation | Out-Null
        }

        # TODO: check for pending reboot on domain join or domain controller creation
        
        $domain_admin_cred = Create-Credential -cred_user $domain_admin_user -cred_pass $domain_admin_pass

        switch($state) {
            domain_controller {
                If(-not $safe_mode_pass) {
                    throw "safe_mode_pass is required for state=domain_controller"
                }

                If($current_dc_domain) {
                    # TODO: implement managed Remove/Add to change domains
                
                    If($current_dc_domain -ne $dns_domain_name) {
                        Throw "$(hostname) is a domain controller for domain $current_dc_domain; changing DC domains is not implemented"
                    }
                }

                # need to promote to DC
                If(-not $current_dc_domain) {
                    Write-DebugLog "Not currently a domain controller; needs promotion"
                    $result.changed = $true
                    If($_ansible_check_mode) {
                        Write-DebugLog "check-mode, exiting early"
                        Return $result
                    }

                    $result.reboot_required = $true

                    $safe_mode_secure = $safe_mode_pass | ConvertTo-SecureString -AsPlainText -Force
                    Write-DebugLog "Installing domain controller..."

                    $install_result = Install-ADDSDomainController -NoRebootOnCompletion -DomainName $dns_domain_name -Credential $domain_admin_cred -SafeModeAdministratorPassword $safe_mode_secure -Force
                    
                    Write-DebugLog "Installation completed, needs reboot..."
                }
            }
            member_server {
                If(-not $local_admin_pass) {
                    throw "local_admin_pass is required for state=domain_controller"
                }
                # at this point we already know we're a DC and shouldn't be...
                Write-DebugLog "Need to uninstall domain controller..."
                $result.changed = $true

                Write-DebugLog "Checking for operation master roles assigned to this DC..."

                $assigned_roles = Get-OperationMasterRoles

                # TODO: figure out a sane way to hand off roles automatically (designated recipient server, randomly look one up?)
                If($assigned_roles.Count -gt 0) {
                    Throw ("This domain controller has operation master role(s) ({0}) assigned; they must be moved to other DCs before demotion (see Move-ADDirectoryServerOperationMasterRole)" -f ($assigned_roles -join ", "))
                }

                If($_ansible_check_mode) {
                    Write-DebugLog "check-mode, exiting early"
                    Return $result
                }

                $result.reboot_required = $true

                $local_admin_secure = $local_admin_pass | ConvertTo-SecureString -AsPlainText -Force

                Write-DebugLog "Uninstalling domain controller..."
                $uninstall_result = Uninstall-ADDSDomainController -NoRebootOnCompletion -LocalAdministratorPassword $local_admin_secure -Credential $domain_admin_cred 
                Write-DebugLog "Uninstallation complete, needs reboot..."

                # we have to initiate the reboot now because domain credentials are no longer valid, 
                # and the local SAM DB isn't usable for auth until after the reboot...

                # note that without an action wrapper, in the case where a DC is demoted,
                # the task will fail with a 401 Unauthorized, because the domain credential
                # becomes invalid to fetch the final output over WinRM. 

                shutdown /r /t 5

                # TODO: remove features

            }
            default { throw ("invalid state {0}" -f $state) }
        }

        return $result
    }
    Catch {
        $excep = $_

        Write-DebugLog "Exception: $($excep | out-string)"

        Throw
    }
}

$p = Parse-Args -arguments $args -supports_check_mode $true

# NB: this conversion only works for flat args
$p.psobject.properties | foreach -begin {$module_args=@{}} -process {$module_args."$($_.Name)" = $_.Value} -end {$module_args} | Out-Null

$result = Module-Impl @module_args

Exit-Json $result




