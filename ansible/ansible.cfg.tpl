[defaults]
host_key_checking               = false
remote_user                     = ${ansible_user}
private_key_file                = ${private_key_file}
roles_path                      = ./roles
collections_paths               = ./collections
allow_world_readable_tmpfiles   = true

[privilege_escalation]
become                          = True
become_method                   = sudo
become_user                     = root