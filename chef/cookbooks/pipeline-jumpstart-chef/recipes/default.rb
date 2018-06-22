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

user 'nexus' do
    uid '200'
    system true
    shell '/bin/bash'
end

directory '/opt/sonatype-work/data' do
    owner 'nexus'
    mode '0755'
    recursive true
    action :create
end

directory '/var/lib/jenkins' do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    recursive true
    action :create
end

directory '/var/lib/postgresql/data' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

execute 'install_docker_compose' do
    command '/usr/bin/curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'
    user 'root'
    not_if { ::File.exist?('/usr/local/bin/docker-compose') }
    notifies :touch, 'file[docker_compose_command_file]', :immediately
end

file 'docker_compose_command_file' do
    path '/usr/local/bin/docker-compose'
    mode '0755'
    owner 'root'
    group 'root'
    notifies :create, 'template[add_docker_compose_yml]', :immediately
end

template 'add_docker_compose_yml' do
    source 'docker-compose.yml.erb'
    path '/opt/docker-compose.yml'
    atomic_update true
    owner 'root'
    group 'root'
    mode '0644'
    action :nothing
    notifies :run, 'execute[start_docker_containers]', :delayed
end

execute 'start_docker_containers' do
    # add -d when it is fixed
    command 'docker-compose -f /opt/docker-compose.yml up'
    user 'root'
    action :nothing
end