Title: Ansible Cheatsheet
Published: 6/12/2020
Tags:
    - Ansible
    - Cheatsheet
    - Draft
---

## Inventory

Global inventory location - /etc/ansible/hosts

List all hosts
```
ansible -i inventory/sandbox --list-hosts all
ansible -i inventory/sandbox --list-hosts *
```

Show single host
```
ansible -i inventory/sandbox --list-hosts app01
```

Wildcard
```
ansible -i inventory/sandbox --list-hosts app*
```

Group
```
ansible -i inventory/sandbox --list-hosts webserver
```

Multiple
```
ansible -i inventory/sandbox --list-hosts webserver:database:lb01
```

Index
```
ansible -i inventory/sandbox --list-hosts webserver[0]
```

Negation (not match)
```
ansible -i inventory/sandbox --list-hosts \!webserver
```

Run on specific subset of hosts
```
ansible-playbook site.yml -i inventory/sandbox --limit app01
ansible-playbook site.yml -i inventory/sandbox --limit \!webserver
```
[More can be found here](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html)

## Tasks

List tags
```
ansible-playbook site.yml -i inventory/sandbox --list-tags
```

Run tags
```
ansible-playbook site.yml -i inventory/sandbox --tags "packages"
```

Skip tags
```
ansible-playbook site.yml -i inventory/sandbox --skip-tags "packages"
```

## Variables

List all facts
```
ansible -i inventory/sandbox -m setup db01 
```

Get environment variable
```
{{ lookup("env", "ENV_VARIABLE") }}
```

## Vault
Create secrets file
```
ansible-vault create secrets
```

Edit secrets file
```
ansible-vault edit secrets
```

Ask for password
```
ansible-playbook database.yml -i inventory/sandbox --ask-vault-pass
```

Use password file
```
ansible-playbook database.yml -i inventory/sandbox --vault-password-file ~/.vault_pass
```

## Troubleshooting

Run step-by-step
```
ansible-playbook database.yml -i inventory/sandbox --step
```

Start at specific task
```
ansible-playbook database.yml -i inventory/sandbox --list-tasks
ansible-playbook database.yml -i inventory/sandbox --start-at-task "Create user"
```

Syntax check
```
ansible-playbook database.yml --syntax-check
```

Dry-run
```
ansible-playbook database.yml -i inventory/sandbox --check
```

List all variables
```
- debug: var=vars
```