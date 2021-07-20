---

ssh_pwauth: True ## This line enables ssh password authentication
users:
  - default
  - name: cycloid
    primary_group: cycloid
    groups: sudo
    lock_passwd: false
    passwd: $6$rounds=4096$M./OnxuQpSGlgtp$54OC5rmTtlqzmQYvJ18UwQCt.NkZeKFvC3Re.Vbo/vdr3oU31n9dolJOmCGZKYEHe7b8ouD7dqNcqOGEXPY1e0
