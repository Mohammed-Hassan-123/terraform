[slavenodes]
slavethree ansible_host=${slavethree_ip} ansible_user=slavethree
slavefour  ansible_host=${slavefour_ip} ansible_user=slavefour

[slavenodes:vars]
ansible_ssh_private_key_file=~/.ssh/id_ed25519
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
