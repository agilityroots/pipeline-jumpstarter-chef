#
# Cookbook:: pipeline-jumpstart-chef
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'java::default'
include_recipe 'nexus3'
include_recipe'jenkins::master'

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