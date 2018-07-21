#!/usr/bin/python

from ansible.module_utils.basic import *

#	module = AnsibleModule(argument_spec={})
#	response = {"hello": "world"}
#	module.exit_json(changed=False, meta=response)

def main():

  fields = {
		"github_auth_key": {"required": True, "type": "str"},
		"name": {"required": True, "type": "str" },
        "description": {"required": False, "type": "str"},
        "private": {"default": False, "type": "bool" },
        "has_issues": {"default": True, "type": "bool" },
        "has_wiki": {"default": True, "type": "bool" },
        "has_downloads": {"default": True, "type": "bool" },
        "state": {
        	"default": "present", 
        	"choices": ['present', 'absent'],  
        	"type": 'str' 
        },
	}

	module = AnsibleModule(argument_spec=fields)
	module.exit_json(changed=False, meta=module.params)

if __name__ == '__main__':
    main()

