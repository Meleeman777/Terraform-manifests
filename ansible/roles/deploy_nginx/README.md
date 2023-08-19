Role Name
=========

A role for deploying nginx`s configs to diffent hosts.

Requirements
------------

No requirements required

Role Variables
--------------

site_available_path: /etc/nginx/sites-available ### Path to a directory for a nginx virtualhosts configs
site_enabled_path: /etc/nginx/sites-enabled     ### Path to a directory for a nginx vritualhosts configs to enable hosts
nginx_path: /etc/nginx                          ### Path to a nginx`s config directory
nginx: nginx.conf 
nginx_state: present                            ### State of nginx
nginxs:                                         ### List of nginx`s configs
  - nginx1.conf
  - nginx2.conf
nginx_settings:                                 ### Map of nginx settings
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
