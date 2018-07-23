#!powershell

# (c) 2015, Matt Davis <mdavis@ansible.com>

# WANT_JSON
# POWERSHELL_COMMON

# TODO: add "default" settings to reset to DHCP-assigned DNS

Set-StrictMode -Version 2

$ErrorActionPreference = "Stop"
$ConfirmPreference = "None"

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

Function Get-DnsClientMatch {
    Param(
        [string] $adapter_name,
        [string[]] $ipv4_addresses
    )

    Write-DebugLog ("Getting DNS config for adapter {0}" -f $adapter_name)
    Try {
        # Try the 2012+ way first
        $current_dns_all = Get-DnsClientServerAddress -InterfaceAlias $adapter_name
        $current_dns_v4 = ($current_dns_all | Where-Object AddressFamily -eq 2 <# IPv4 #>).ServerAddresses
    }
    Catch {
        # Must be older system < 2012
       If ($adapter_name -eq '*'){
           $current_dns_all = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "TRUE"}
           $current_dns_v4 = $current_dns_all.DNSServerSearchOrder
       }
       Else {
           $current_dns_all = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "TRUE" -and $_.Description -eq $adapter_name}
           $current_dns_v4 = $current_dns_all.DNSServerSearchOrder
       }
    }

    Write-DebugLog ("Current DNS settings: " + $($current_dns_all | Out-String))


    $v4_match = @(Compare-Object $current_dns_v4 $ipv4_addresses).Count -eq 0
    
    # TODO: implement IPv6

    Write-DebugLog ("Current DNS settings match ({0}) : {1}" -f ($ipv4_addresses -join ", "), $v4_match)

    return $v4_match
}

Function Validate-IPAddress {
    Param([string] $address)
    Try {
        [ipaddress]$address
    }
    Catch {
        return $false
    }

    return $true
}

Function Set-DnsClientAddresses
{
    Param(
        [string] $adapter_name,
        [string[]] $ipv4_addresses
    )

    Write-DebugLog ("Setting DNS addresses for adapter {0} to ({1})" -f $adapter_name, ($ipv4_addresses -join ", "))

    If ($is_2012){
        # this silently ignores invalid IPs, so we validate parseability ourselves up front...
        Set-DnsClientServerAddress -InterfaceAlias $adapter_name -ServerAddresses $ipv4_addresses
    }
    Else {
        $adapter = Get-WMIObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "TRUE" -and $_.Description -eq $adapter_name}
        $addresses = $ipv4_addresses -join ","
        $adapter.SetDNSServerSearchOrder($addresses)
    }

    # TODO: implement IPv6
}

Function Module-Impl {
    Param(
        [string]$adapter_names = "*",
        [string[]]$ipv4_addresses,
        [string]$log_path = $null,
        [bool]$check_mode = $false
    )

    $global:log_path = $log_path

    Try {
        $changed = $false

        Write-DebugLog ("Validating adapter name {0}" -f $adapter_names)

        $adapters = @($adapter_names)

        If($adapter_names -eq "*") {
            If ($is_2012) {
            $adapters = Get-NetAdapter | Select-Object -ExpandProperty Name
            }
            Else {
            $adapters = Get-WmiObject Win32_NetworkAdapterconfiguration -filter "ipenabled = 'true'" | % {$_.Description}
            }
        }
        # TODO: add support for an actual list of adapter names
        # validate network adapter names
        Else {
            If ($is_2012) {
                Try {
                    @(Get-NetAdapter | Where-Object Name -eq $adapter_names).Count -eq 0 
                }
                Catch {
                    Fail-Json "Invalid network adapter name: {0}" -f $adapter_names
                }
            }
            Else {
                Try {
                    @(Get-WmiObject Win32_NetworkAdapterconfiguration -filter "ipenabled = 'true'" | Where-Object Description -eq $adapter_names).Count -eq 0
                }
                Catch {
                    Fail-Json "Invalid network adapter name: {0}" -f $adapter_names
                }

            }
        }

        Write-DebugLog ("Validating IP addresses ({0})" -f ($ipv4_addresses -join ", "))

        $invalid_addresses = @($ipv4_addresses | ? { -not (Validate-IPAddress $_) })

        If($invalid_addresses.Count -gt 0) {
            throw "Invalid IP address(es): ({0})" -f ($invalid_addresses -join ", ")
        }

        ForEach($adapter_name in $adapters) {
            $changed = $changed -or (-not (Get-DnsClientMatch $adapter_name $ipv4_addresses))

            If($changed) {
                If(-not $check_mode) {
                    Set-DnsClientAddresses $adapter_name $ipv4_addresses
                }
                Else {
                    Write-DebugLog "Check mode, skipping"
                }
            }
        }

        $result.changed = $changed

    }
    Catch {
        $excep = $_

        Write-DebugLog "Exception: $($excep | out-string)"

        Throw
    }
}

$is_2012 = $true
If([System.Environment]::OSVersion.Version -lt [Version]"6.3.9600.0"){
    $is_2012 = $false
}

$result = New-Object psobject @{
    changed = $false
};

$p = Parse-Args -arguments $args -supports_check_mode $true

# NB: this conversion only works for flat args
$p.psobject.properties | foreach -begin {$module_args=@{}} -process {$module_args."$($_.Name)" = $_.Value} -end {$module_args} | Out-Null

Module-Impl @module_args

Exit-Json $result

