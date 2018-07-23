#!/usr/bin/python

DOCUMENTATION='''
'''

EXAMPLES='''
  # set a single address on the adapter named Ethernet 
  - win_dns_client:
      adapter_names: Ethernet
      ipv4_addresses: 192.168.34.5

  # set multiple addresses on all adapters, with debug logging to a file
  - win_dns_client:
      adapter_names: "*"
      ipv4_addresses: 
      - 192.168.34.5
      - 192.168.34.6
      log_path: c:\\dns_log.txt
'''

