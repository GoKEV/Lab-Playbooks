#!powershell
# This file is part of Ansible
#
# Copyright 2015, Hans-Joachim Kliemeck <git@kliemeck.de>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# WANT_JSON
# POWERSHELL_COMMON

#Functions
Function UserSearch
{
    Param ([string]$accountName)

    $objUser = New-Object System.Security.Principal.NTAccount("$accountName")
    Try {
        $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
        return $strSID.Value
    }
    Catch {
        Fail-Json $result "$user is not a valid user or group on the host machine or domain"
    }
}
 
$params = Parse-Args $args;

$result = New-Object PSObject;
Set-Attr $result "changed" $false;

$path = Get-Attr $params "path" -failifempty $true
$user = Get-Attr $params "user" -failifempty $true
$recurse = Get-Attr $params "recurse" "no" -validateSet "no","yes" -resultobj $result
$recurse = $recurse | ConvertTo-Bool

If (-Not (Test-Path -Path $path)) {
    Fail-Json $result "$path file or directory does not exist on the host"
}

# Test that the user/group is resolvable on the local machine
$sid = UserSearch -AccountName ($user)

Try {
    $objUser = New-Object System.Security.Principal.SecurityIdentifier($sid)

    $file = Get-Item -Path $path
    $acl = Get-Acl $file.FullName

    If ($acl.getOwner([System.Security.Principal.SecurityIdentifier]) -ne $objUser) {
        $acl.setOwner($objUser)
        Set-Acl $file.FullName $acl

        Set-Attr $result "changed" $true;
    }

    If ($recurse) {
        $files = Get-ChildItem -Path $path -Force -Recurse
        ForEach($file in $files){
            $acl = Get-Acl $file.FullName

            If ($acl.getOwner([System.Security.Principal.SecurityIdentifier]) -ne $objUser) {
                $acl.setOwner($objUser)
                Set-Acl $file.FullName $acl

                Set-Attr $result "changed" $true;
            }
        }
    }
}
Catch {
    Fail-Json $result "an error occured when attempting to change owner on $path for $user"
}

Exit-Json $result
