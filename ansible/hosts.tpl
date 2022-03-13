[masters]
master ansible_host=${master_ip} ansible_user=packer.prod

[workers]
worker01 ansible_host=${worker1_ip} ansible_user=packer.prod
worker02 ansible_host=${worker2_ip} ansible_user=packer.prod