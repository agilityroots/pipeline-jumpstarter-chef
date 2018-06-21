#
# Cookbook:: pipeline-jumpstart-chef
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'java::default'
# Use Docker APT for installation
include_recipe 'chef-apt-docker'

# Install Docker
docker_installation_package 'default' do
    action :create
    package_options %q|--force-yes -o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-all'| # if Ubuntu for example
end

# Start docker conainter service
docker_service 'default' do
    action [:start]
end
# setup system startup options
docker_service_manager 'default' do
    action [:start]
end

## Add directories for mapping volumes
directory '/opt/sonarqube/conf' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

directory '/opt/sonarqube/data' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

directory '/opt/sonarqube/extensions' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

directory '/opt/sonarqube/bundled-plugins' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

directory '/opt/sonatype-work/data' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

directory '/var/lib/jenkins' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

directory '/var/lib/postgres/data' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

template '/opt/docker-compose.yml' do
    source 'docker-compose.yml.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create_if_missing
end