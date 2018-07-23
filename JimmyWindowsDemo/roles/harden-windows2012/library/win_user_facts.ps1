#!powershell
# This file is part of Ansible
#
# Copyright 2017, Red Hat Inc
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

Set-StrictMode -Version Latest

# Get the name from all local accounts
$allusers = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount = 'True'" | Select Name | Sort

# Turn dictionary into a list
$userlist = @($allusers | foreach { $_.Name } )

$result = New-Object psobject @{
    ansible_facts = New-Object psobject
    changed = $false
}

Set-Attr $result.ansible_facts "win_users" $userlist

Exit-Json $result
