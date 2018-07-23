#!powershell
# This file is part of Ansible
#
# Copyright 2016, Red Hat Inc
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

function Get-IniContent
{
    param (
        [parameter(mandatory=$true, position=0, valuefrompipelinebypropertyname=$true, valuefrompipeline=$true)][string]$FilePath
    )

    $ini = @{}
    switch -regex (Get-Content $FilePath)
    {
        "^\[(.+)\]" # Section
        {
            $section = $matches[1].trim().replace(" ", "_")
            $ini[$section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$" # Comment
        {
            $value = $matches[1].trim()
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        } 
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name.trim().replace(" ", "_")] = $value.trim()
        }
    }
    return $ini
}

$result = New-Object psobject @{
    ansible_facts = New-Object psobject
    changed = $false
}
$secedit = New-Object psobject
$sepath = "$env:temp\sec_edit_dump.inf"
SecEdit.exe /export /cfg $sepath /quiet
$ini = Get-IniContent -FilePath $sepath
Set-Attr $result.ansible_facts "secedit_rules" $ini

rm $env:temp\sec_edit_dump.inf

Exit-Json $result
