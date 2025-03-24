#cloud-config
users:
  - default
  - name: cycloid
    primary_group: cycloid
    groups: sudo
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    lock_passwd: false
    shell: /bin/bash

cloud_config_modules:
  - runcmd

cloud_final_modules:
  - scripts-user

# Enabled tunneled clear text passwords, DO NOT use it in production. Only for testing purpose
# To install SSM Agent on Debian Server
# https://docs.aws.amazon.com/systems-manager/latest/userguide/agent-install-deb.html
runcmd:
  - (echo '${password}'; echo '${password}') | passwd cycloid # Change the password of the cycloid user
  - sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - systemctl restart ssh
  - mkdir /tmp/ssm
  - cd /tmp/ssm
  - wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
  - dpkg -i amazon-ssm-agent.deb
  - systemctl enable amazon-ssm-agent
  - systemctl start amazon-ssm-agent
