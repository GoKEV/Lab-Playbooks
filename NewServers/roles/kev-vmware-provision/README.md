Role Name
=========

This role allows a user to leverage an existing VMware template to deploy and customize to a new VM

Requirements
------------

https://docs.ansible.com/ansible/latest/modules/vmware_guest_module.html
vmware_guest module documentation shows requirements of python >= 2.6 and PyVmomi


Role Variables
--------------
---
# defaults file for kev-vmware-provision/---

vmware_datacenter: 'KEV Datacenter'
vmware_new_hostname: AnsiBuilt001
vmware_template_name: CentOS7-64-Tempalte
vmware_guest_type: centos7_64Guest
vmware_datastore: VMNFS
vmware_folder: '/'
vmware_disk_size: 20
vmware_ram_mb: 512
vm_cpu_count: 1
vm_core_per_cpu: 1
vmware_network: VLAN20
vmware_state: poweredon

# optional network variables.  Use one, some, or all of them as you desire.
# Without these, your new VM will ask for automatic values from VMware or DHCP:

vmware_manual_ip: 10.10.10.100
vmware_manual_netmask: 255.255.255.0
vmware_manual_mac: aa:bb:dd:aa:00:14














Dependencies
------------

no galaxy or external role dependencies.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
