#!/bin/bash

useradd -p $(openssl passwd -1 ${password}) cycloid
usermod -a -G sudo cycloid

sed -i "s/^PasswordAuthentication .*//g" /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
systemctl restart sshd.service
