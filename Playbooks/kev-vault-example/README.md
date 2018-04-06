# Ansible Playbooks

This project has these files:
  - my_encrypted_file.yml  (encrypted file with ansible-vault) the password is:   redhat
  - vault_playbook_example.yml  (the playbook)
  - localhost.target (inventory)

> ansible-playbook -i localhost.target vault_playbook_example.yml --ask-vault-pass

[![N|Solid](http://gokev.com/GoKEVicon300.png)](https://goKev.com)

> In Ansible Tower, when a "vault credential" type is defined and entered into an Ansible Tower job template, Tower will decrypt the vault-encrypted file on the fly without prompting.  In this example above, it should seamlessly display the text.

