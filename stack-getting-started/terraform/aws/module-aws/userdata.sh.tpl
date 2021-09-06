#cloud-config
users:
  - default
  - name: cycloid
    primary_group: cycloid
    groups: sudo
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock_passwd: false
    shell: /bin/bash

cloud_config_modules:
  - runcmd

cloud_final_modules:
  - scripts-user

# Enabled tunneled clear text passwords, DO NOT use it in production. Only for testing purpose
runcmd:
  - (echo '${password}'; echo '${password}') | passwd cycloid # Change the password of the cycloid user
  - sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - systemctl restart ssh