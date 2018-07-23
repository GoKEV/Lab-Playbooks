#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright 2016, Red Hat Inc  
#
# This file is part of Ansible
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

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_secedit_facts
version_added: '2.3'
short_description: Gets facts about local security policies via secedit
description:
    - Gathers key values for local security policies from secedit. Note that all the return examples are not guaranteed to be present. Secedit removes all keys that have blank values, so systems that do not have anything set for a given key will not be returned. Also note that the categories are returned with the spaces replaced with underscores since they are keys in the dictionary.
options: {}
author:
    - James Mighion (@jmighion) 
'''

EXAMPLES = '''
# Gather all secedit facts
- name: Gather secedit facts 
win_secedit_facts:

'''

RETURN = '''
# Event Audit
AuditAccountLogon: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditAccountManage: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditDSAccess: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditLogonEvents: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditObjectAccess: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditPolicyChange: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditPrivilegeUse: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditProcessTracking: 
    description:
    returned: if exists
    type: string
    sample: 0
AuditSystemEvents: 
    description:
    returned: if exists
    type: string
    sample: 0

# Privilege Rights
SeAssignPrimaryTokenPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-20
SeAuditPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-20
SeBackupPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-551
SeBatchLogonRight: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-551,*S-1-5-32-559,*S-1-5-32-568
SeChangeNotifyPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-1-0,*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-32-545,*S-1-5-32-551
SeCreateGlobalPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6
SeCreatePagefilePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeCreateSymbolicLinkPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeDebugPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeImpersonatePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-32-568,*S-1-5-6
SeIncreaseBasePriorityPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeIncreaseQuotaPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-20,*S-1-5-32-544
SeIncreaseWorkingSetPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-545
SeInteractiveLogonRight: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-545,*S-1-5-32-551
SeLoadDriverPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeManageVolumePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeNetworkLogonRight: 
    description:
    returned: if exists
    type: string
    sample: *S-1-1-0,*S-1-5-32-544,*S-1-5-32-545,*S-1-5-32-551
SeProfileSingleProcessPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeRemoteInteractiveLogonRight: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-555
SeRemoteShutdownPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeRestorePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-551
SeSecurityPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeServiceLogonRight: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-80-0
SeShutdownPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-32-551
SeSystemEnvironmentPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeSystemProfilePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544,*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420
SeSystemtimePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-32-544
SeTakeOwnershipPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544
SeTimeZonePrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-19,*S-1-5-32-544
SeUndockPrivilege: 
    description:
    returned: if exists
    type: string
    sample: *S-1-5-32-544

# Registry Values
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Setup\\\\RecoveryConsole\\\\SecurityLevel: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Setup\\\\RecoveryConsole\\\\SetCommand: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\CachedLogonsCount: 
    description:
    returned: if exists
    type: string
    sample: 1,\\"10\\" 
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\ForceUnlockLogon: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\PasswordExpiryWarning: 
    description:
    returned: if exists
    type: string
    sample: 4,5 
MACHINE\\\\Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Winlogon\\\\ScRemoveOption: 
    description:
    returned: if exists
    type: string
    sample: 1,\\"0\\" 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\ConsentPromptBehaviorAdmin: 
    description:
    returned: if exists
    type: string
    sample: 4,5 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\ConsentPromptBehaviorUser: 
    description:
    returned: if exists
    type: string
    sample: 4,3 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\DisableCAD: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\DontDisplayLastUserName: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\EnableInstallerDetection: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\EnableLUA: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\EnableSecureUIAPaths: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\EnableUIADesktopToggle: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\EnableVirtualization: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\FilterAdministratorToken: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\LegalNoticeCaption: 
    description:
    returned: if exists
    type: string
    sample: 1,\\"\\" 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\LegalNoticeText: 
    description:
    returned: if exists
    type: string
    sample: 7, 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\PromptOnSecureDesktop: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\ScForceOption: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\ShutdownWithoutLogon: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\UndockWithoutLogon: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\System\\\\ValidateAdminCodeSignatures: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\Software\\\\Policies\\\\Microsoft\\\\Windows\\\\Safer\\\\CodeIdentifiers\\\\AuthenticodeEnabled: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\AuditBaseObjects: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\CrashOnAuditFail: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\DisableDomainCreds: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\EveryoneIncludesAnonymous: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\FIPSAlgorithmPolicy\\\\Enabled: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\ForceGuest: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\FullPrivilegeAuditing: 
    description:
    returned: if exists
    type: string
    sample: 3,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\LimitBlankPasswordUse: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\MSV1_0\\\\NTLMMinClientSec: 
    description:
    returned: if exists
    type: string
    sample: 4,536870912 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\MSV1_0\\\\NTLMMinServerSec: 
    description:
    returned: if exists
    type: string
    sample: 4,536870912 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\NoLMHash: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\RestrictAnonymous: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Lsa\\\\RestrictAnonymousSAM: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Print\\\\Providers\\\\LanMan Print Services\\\\Servers\\\\AddPrinterDrivers: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\SecurePipeServers\\\\Winreg\\\\AllowedExactPaths\\\\Machine: 
    description:
    returned: if exists
    type: string
    sample: 7,System\\\\CurrentControlSet\\\\Control\\\\ProductOptions,System\\\\CurrentControlSet\\\\Control\\\\Server Applications,Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\SecurePipeServers\\\\Winreg\\\\AllowedPaths\\\\Machine: 
    description:
    returned: if exists
    type: string
    sample: 7,System\\\\CurrentControlSet\\\\Control\\\\Print\\\\Printers,System\\\\CurrentControlSet\\\\Services\\\\Eventlog,Software\\\\Microsoft\\\\OLAP Server,Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Print,Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Windows,System\\\\CurrentControlSet\\\\Control\\\\ContentIndex,System\\\\CurrentControlSet\\\\Control\\\\Terminal Server,System\\\\CurrentControlSet\\\\Control\\\\Terminal Server\\\\UserConfig,System\\\\CurrentControlSet\\\\Control\\\\Terminal Server\\\\DefaultUserConfiguration,Software\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\\\\Perflib,System\\\\CurrentControlSet\\\\Services\\\\SysmonLog 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Kernel\\\\ObCaseInsensitive: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Memory Management\\\\ClearPageFileAtShutdown: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\ProtectionMode: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\SubSystems\\\\optional: 
    description:
    returned: if exists
    type: string
    sample: 7, 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LDAP\\\\LDAPClientIntegrity: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\AutoDisconnect: 
    description:
    returned: if exists
    type: string
    sample: 4,15 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\EnableForcedLogOff: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\EnableSecuritySignature: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\NullSessionPipes: 
    description:
    returned: if exists
    type: string
    sample: 7,,netlogon,samr,lsarpc 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\RequireSecuritySignature: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanManServer\\\\Parameters\\\\RestrictNullSessAccess: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanmanWorkstation\\\\Parameters\\\\EnablePlainTextPassword: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanmanWorkstation\\\\Parameters\\\\EnableSecuritySignature: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\LanmanWorkstation\\\\Parameters\\\\RequireSecuritySignature: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\NTDS\\\\Parameters\\\\LDAPServerIntegrity: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\DisablePasswordChange: 
    description:
    returned: if exists
    type: string
    sample: 4,0 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\MaximumPasswordAge: 
    description:
    returned: if exists
    type: string
    sample: 4,30 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\RequireSignOrSeal: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\RequireStrongKey: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\SealSecureChannel: 
    description:
    returned: if exists
    type: string
    sample: 4,1 
MACHINE\\\\System\\\\CurrentControlSet\\\\Services\\\\Netlogon\\\\Parameters\\\\SignSecureChannel: 
    description:
    returned: if exists
    type: string
    sample: 4,1

# System Access
ClearTextPassword: 
    description:
    returned: if exists
    type: string
    sample: 0 
EnableAdminAccount: 
    description:
    returned: if exists
    type: string
    sample: 1 
EnableGuestAccount: 
    description:
    returned: if exists
    type: string
    sample: 0 
ForceLogoffWhenHourExpire: 
    description:
    returned: if exists
    type: string
    sample: 0 
LSAAnonymousNameLookup: 
    description:
    returned: if exists
    type: string
    sample: 0 
LockoutBadCount: 
    description:
    returned: if exists
    type: string
    sample: 0 
MaximumPasswordAge: 
    description:
    returned: if exists
    type: string
    sample: 42 
MinimumPasswordAge: 
    description:
    returned: if exists
    type: string
    sample: 1 
MinimumPasswordLength: 
    description:
    returned: if exists
    type: string
    sample: 7 
NewAdministratorName: 
    description:
    returned: if exists
    type: string
    sample: \\"Administrator\\" 
NewGuestName: 
    description:
    returned: if exists
    type: string
    sample: \\"Guest\\" 
PasswordComplexity: 
    description:
    returned: if exists
    type: string
    sample: 1 
PasswordHistorySize: 
    description:
    returned: if exists
    type: string
    sample: 24 
RequireLogonToChangePassword: 
    description:
    returned: if exists
    type: string
    sample: 0

# Unicode
Unicode: 
    description:
    returned: if exists
    type: string
    sample: yes

# Version
Revision: 
    description:
    returned: if exists
    type: string
    sample: 1
signature: 
    description:
    returned: if exists
    type: string
    sample: \\"$CHICAGO$\\"
'''