#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright 2017, Red Hat Inc
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
module: win_user_facts
version_added: '2.3'
short_description: Get list of user accoutns
description:
    - Gathers list of user accounts.
options: {}
author:
    - Sam Doran <sdoran@redhat.com>
'''

EXAMPLES = '''
# Gather all secedit facts
- name: Gather user accounts
  win_user_facts:

'''

RETURN = '''
winusers:
    description: List of user accounts
    returned: always
    type: list
    sample: ['Guest', 'Administrator']
'''
