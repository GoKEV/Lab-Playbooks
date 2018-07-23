#!/usr/bin/python

DOCUMENTATION='''

'''

EXAMPLES='''

# host should be a member of domain ansible.vagrant; module will ensure the hostname is mydomainclient
# and will use the passed credentials to join domain if necessary.
# Ansible connection should use local credentials if possible.
- hosts: winclient
  gather_facts: no
  tasks:
  - win_domain_membership:
      dns_domain_name: ansible.vagrant
      hostname: mydomainclient
      domain_admin_user: testguy@ansible.vagrant
      domain_admin_pass: password123!
      state: domain


# host should be in workgroup mywg- module will use the passed credentials to clean-unjoin domain if possible.
# Ansible connection should use local credentials if possible.
- hosts: winclient
  gather_facts: no
  tasks:
  - win_domain_membership:
      workgroup_name: mywg
      domain_admin_user: testguy@ansible.vagrant
      domain_admin_pass: password123!
      state: workgroup

'''
