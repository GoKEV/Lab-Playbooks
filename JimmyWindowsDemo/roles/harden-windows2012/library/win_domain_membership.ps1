#!powershell

# (c) 2015, Matt Davis <mdavis@ansible.com>

# WANT_JSON
# POWERSHELL_COMMON

Set-StrictMode -Version 2

$ErrorActionPreference = "Stop"

$log_path = $null

Function Write-DebugLog {
    Param(
    [string]$msg
    )

    $DebugPreference = "Continue"
    $date_str = Get-Date -Format u
    $msg = "$date_str $msg"

    Write-Debug $msg

    if($log_path) {
        Add-Content $log_path $msg
    }
}

Function Get-DomainMembershipMatch {
    Param(
        [string] $dns_domain_name
    )

    # TODO: add support for NetBIOS domain name?

    # this requires the DC to be accessible; "DC unavailable" is indistinguishable from "not joined to the domain"...
    Try {
        Write-DebugLog "calling GetComputerDomain()"
        $current_dns_domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().Name

        $domain_match = $current_dns_domain -eq $dns_domain_name

        Write-DebugLog ("current domain {0} matches {1}: {2}" -f $current_dns_domain, $dns_domain_name, $domain_match)

        return $domain_match
    }
    Catch [System.DirectoryServices.ActiveDirectory.ActiveDirectoryObjectNotFoundException] {
        Write-DebugLog "not currently joined to a reachable domain"
        return $false
    }
}

Function Create-Credential {
    Param(
        [string] $cred_user,
        [string] $cred_pass
    )

    $cred = New-Object System.Management.Automation.PSCredential($cred_user, $($cred_pass | ConvertTo-SecureString -AsPlainText -Force))

    return $cred
}

Function Get-HostnameMatch {
    Param(
        [string] $hostname
    )

    # Add-Computer will validate the "shape" of the hostname- we just care if it matches...

    $hostname_match = $env:COMPUTERNAME -eq $hostname
    Write-DebugLog ("current hostname {0} matches {1}: {2}" -f $env:COMPUTERNAME, $hostname, $hostname_match)

    return $hostname_match
}

Function Is-DomainJoined {
    return (Get-WmiObject Win32_ComputerSystem).PartOfDomain
}

Function Join-Domain {
    Param(
        [string] $dns_domain_name,
        [string] $new_hostname,
        [string] $domain_admin_user,
        [string] $domain_admin_pass
    )

    Write-DebugLog ("Creating credential for user {0}" -f $domain_admin_user)
    $domain_cred = Create-Credential $domain_admin_user $domain_admin_pass
    
    $add_args = @{
        ComputerName="."
        Credential=$domain_cred
        DomainName=$dns_domain_name
        Force=$null
    }

    Write-DebugLog "adding hostname set arg to Add-Computer args"
    If($new_hostname) {
        $add_args["NewName"] = $new_hostname
    }

    Write-DebugLog "calling Add-Computer"
    $add_result = Add-Computer @add_args

    Write-DebugLog ("Add-Computer result was \n{0}" -f $add_result | Out-String)
}

Function Get-Workgroup {
    return (Get-WmiObject Win32_ComputerSystem).Workgroup
}

Function Set-Workgroup {
    Param(
        [string] $workgroup_name
    )

    Write-DebugLog ("Calling JoinDomainOrWorkgroup with workgroup {0}" -f $workgroup_name)

    return (Get-WmiObject Win32_ComputerSystem).JoinDomainOrWorkgroup($workgroup_name)
}

Function Join-Workgroup {
    Param(
        [string] $workgroup_name,
        [string] $domain_admin_user,
        [string] $domain_admin_pass
    )

    If(Is-DomainJoined) { # if we're on a domain, unjoin it (which forces us to join a workgroup)
        $domain_cred = Create-Credential $domain_admin_user $domain_admin_pass

        $rc_result = Remove-Computer -WorkgroupName $workgroup_name -Credential $domain_cred -Force
    }

    # we're already on a workgroup- change it.
    Else {
        $swg_result = Set-Workgroup $workgroup_name
    }
}

Function Module-Impl {
    Param(
        [string] $dns_domain_name,
        [string] $hostname,
        [string] $workgroup_name,
        [string] $domain_admin_user,
        [string] $domain_admin_pass,
        [string] $state, # domain, workgroup
        [string] $log_path = $null,
        [bool] $_ansible_check_mode = $false # default to false since 1.x won't pass this
    )

    # TODO: validate args

    $global:log_path = $log_path

    Try {

        $result = @{
            changed = $false
            reboot_required = $false
        }

        $hostname_match = If($hostname) { Get-HostnameMatch $hostname } Else { $true }

        $result.changed = $result.changed -or (-not $hostname_match)

        Switch($state) {
            domain {
                $domain_match = Get-DomainMembershipMatch $dns_domain_name

                $result.changed = $result.changed -or (-not $domain_match)

                If($result.changed -and -not $_ansible_check_mode) {
                    If(-not $domain_match) {
                        If(Is-DomainJoined) {
                            Write-DebugLog "domain doesn't match, and we're already joined to another domain"
                            throw "switching domains is not implemented"
                        }
                                
                        $join_args = @{
                            dns_domain_name = $dns_domain_name
                            domain_admin_user = $domain_admin_user
                            domain_admin_pass = $domain_admin_pass
                        }

                        Write-DebugLog "not a domain member, joining..."

                        If(-not $hostname_match) {
                            Write-DebugLog "adding hostname change to domain-join args"
                            $join_args.new_hostname = $hostname
                        }

                        $join_result = Join-Domain @join_args
                    }
                    ElseIf(-not $hostname_match) { # domain matches but hostname doesn't, just do a rename
                        Write-DebugLog ("domain matches, setting hostname to {0}" -f $hostname)
                        $rename_result = Rename-Computer -NewName $hostname
                    }

                    # all these changes require a reboot
                    $result.reboot_required = $true
                }
                Else {
                    Write-DebugLog "check mode, exiting early..."
                }

            }

            workgroup {
                $workgroup_match = $(Get-Workgroup) -eq $workgroup_name

                $result.changed = $result.changed -or (-not $workgroup_match)

                If(-not $_ansible_check_mode) {
                    If(-not $workgroup_match) {
                        Write-DebugLog ("setting workgroup to {0}" -f $workgroup_name)
                        $join_wg_result = Join-Workgroup -workgroup_name $workgroup_name -domain_admin_user $domain_admin_user -domain_admin_pass $domain_admin_pass
                        $result.reboot_required = $true
                    }
                    If(-not $hostname_match) {
                        Write-DebugLog ("setting hostname to {0}" -f $hostname)
                        $rename_result = Rename-Computer -NewName $hostname
                        $result.reboot_required = $true
                    }
                }
            }
            default { throw "invalid state $state" }
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

# NB: this conversion only works for flat args...
$p.psobject.properties | foreach -begin {$module_args=@{}} -process {$module_args."$($_.Name)" = $_.Value} -end {$module_args} | Out-Null

$result = Module-Impl @module_args 

Exit-Json $result

# TODO: detect pending restart for rename and fail (check HKLM\System\Control\CurrentControlSet\ComputerName\ComputerName and ActiveComputerName
# TODO: detect pending restart for domain join/unjoin/workgroup change (how?)

