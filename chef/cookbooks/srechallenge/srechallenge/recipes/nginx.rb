#
# Cookbook Name:: srechallenge
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

include_recipe 'chef_nginx::default'

#executables 
openssl = '/usr/bin/openssl'

#variables
nginx_ssl_dir = '/etc/nginx/ssl'
ssl_keyfile = File.join(nginx_ssl_dir, 'sre_challenge.key')
ssl_crtfile = File.join(nginx_ssl_dir, 'sre_challenge.crt')
subject = '/C=US/ST=Pennsylvania/L=Philadelphia/O=private/OU=private/CN=srechallenge.com'


directory nginx_ssl_dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'create self-sgined cert' do
  user 'root'
  command "#{openssl} req -x509 -nodes -days 365 -newkey rsa:2048 -subj #{subject} -keyout #{ssl_keyfile} -out #{ssl_crtfile}"
end

directory '/var/www/sre_challenge' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
  action :create
end

cookbook_file '/var/www/sre_challenge/index.html' do
    owner 'www-data'
    group 'www-data'
    source 'index.html'
    mode '0644'
end

nginx_site 'Enable sre_challenge site' do
  template 'sre_challenge.erb'
  name 'sre_challenge'
  action :enable
  notifies :restart, 'service[nginx]', :delayed
end
