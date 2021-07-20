#cloud-config
ssh_pwauth: True ## This line enables ssh password authentication
users:
  - default
  - name: cycloid
    primary_group: cycloid
    groups: sudo
    lock_passwd: false

# Using chpasswd module instead of password field in previous users one because
# we want to generate a random password using Terraform. And unfortunatly generating a mkpasswd
# is not possible
chpasswd:
    list: |
        cycloid:${password}
    expire: False
