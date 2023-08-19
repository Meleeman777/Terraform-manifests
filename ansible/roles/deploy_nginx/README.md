Role Name
=========

A role for deploying nginx`s configs to diffent hosts.

Requirements
------------

No requirements required

Role Variables
--------------
### Path to a directory for a nginx virtualhosts configs
site_available_path: /etc/nginx/sites-available 
### Path to a directory for a nginx vritualhosts configs to enable hosts
site_enabled_path: /etc/nginx/sites-enabled     
### Path to a nginx`s config directory
nginx_path: /etc/nginx                          
nginx: nginx.conf 
### State of nginx
nginx_state: present  
### List of nginx`s configs
nginxs: 
  - nginx1.conf
  - nginx2.conf
### Map of nginx`s settings
nginx_settings:
  - key:  sendfile
    value: "on"
  - key: tcp_nopush
    value: "on"
  - key: keepalive_timeout
    value:  "70"
  - key: gzip
    value:  "on"


Dependencies
------------

No dependencies required

Example Playbook
----------------

How to use:

 hosts: all

 roles:
   - deploy_nginx

License
-------

BSD

Author Information
------------------

Be free to ask questions on my telegram @Meleeman777
