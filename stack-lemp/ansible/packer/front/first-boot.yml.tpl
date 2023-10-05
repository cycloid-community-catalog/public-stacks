---
- hosts: localhost
  connection: local
  remote_user: root
  become: yes
  vars:
    ami_hostname: "{{ ansible_hostname }}"
    ami_ip_address: "{{ ansible_default_ipv4.address }}"
{% raw %}
    ami_client: "{{ client }}"
    ami_role: "{{ role }}"
    ami_project: "{{ project }}"
    ami_env: "{{ env }}"
  tasks:
   - pip: name={{item}} state=latest
     with_items:
     - awscli
     - boto

   - name: Gather ec2 facts
     ec2_metadata_facts:

   - name: Retrieve all tags on an instance
     ec2_tag:
       region: '{{ ansible_ec2_placement_region }}'
       resource: '{{ ansible_ec2_instance_id }}'
       state: list
     register: ec2_tags

   - name: "Set facts with hostname"
     set_fact: ansible_hostname="{{ ami_client|lower }}-{{ ami_project|lower }}-{{ ami_role|lower }}-{{ ami_env|lower }}-{{ ansible_ec2_instance_id }}"

   - name: "Setup instance hostname"
     hostname: name="{{ ansible_hostname }}"

   - name: "Setup instance AWS Hosts file"
     lineinfile: dest=/etc/hosts
                 regexp='^{{ ansible_default_ipv4.address }}.*'
                 line="{{ ansible_default_ipv4.address }} {{ ansible_hostname }}"
                 state=present

   - name: "Find files containing packer's hostname"
     shell: grep -iR "{{ ami_hostname }}" /etc/ | grep -v 'Binary' | cut -f 1 -d ':' |  sort -u
     register: relics_hostname

   - name: "Replace all occurences of packer's hostname"
     replace:
       dest: "{{ item }}"
       regexp: "{{ ami_hostname }}"
       replace: "{{ ansible_hostname }}"
     with_items: "{{ relics_hostname.stdout_lines }}"

   - name: "Find files containing packer's IP address"
     shell: grep -iR "{{ ami_ip_address }}" /etc/ | grep -v 'Binary' | cut -f 1 -d ':' |  sort -u
     register: relics_ip_address

   - name: "Replace all occurences of packer's IP address"
     replace:
       dest: "{{ item }}"
       regexp: "{{ ami_ip_address }}"
       replace: "{{ ansible_default_ipv4.address }}"
     with_items: "{{ relics_ip_address.stdout_lines }}"

{% endraw %}
