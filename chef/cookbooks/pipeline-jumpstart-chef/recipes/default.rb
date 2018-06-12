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

directory '/var/lib/mysql' do
    group 'docker'
    action :create
end

# Get Images
docker_image 'mysql/mysql-server' do
    tag '5.7'
    action :pull
end

docker_image 'sonatype/nexus3' do
    tag '3.12.1'
    action :pull
end

docker_image 'sonarqube' do
    tag '7.1'
    action :pull
end

docker_image 'agilityroots/jenkins' do
    tag '1.0'
    action :pull
end

# Install MySQL for Sonar
docker_container 'mysql-server' do
    repo 'mysql/mysql-server'
    tag '5.7'
    env ['MYSQL_ROOT_PASSWORD=Son1rQub5','MYSQL_DATABASE=sonar','MYSQL_USER=sonar','MYSQL_PASSWORD=Son1rQub5']
    port '3036'
    volumes ['/var/lib/mysql:/var/lib/mysql']
    network_mode 'host'
    action :run
end

# Launch SonarQube Container
directory '/opt/sonarqube' do
    action :create
end

directory '/opt/sonarqube/data' do
    action :create
end

docker_container 'sonarqube' do
    repo 'sonarqube'
    tag '7.1'
    port ['9000','9092']
    env ['SONARQUBE_JDBC_PASSWORD=Son1rQub5','SONARQUBE_JDBC_URL=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true']
    network_mode 'host'
    action :run
end

# Nexus 3 Container
directory '/opt/sonatype-work' do
    action :create
end

directory '/opt/sonatype-work/nexus3' do
    action :create
end

docker_container 'nexus3' do
    repo 'sonatype/nexus3'
    tag '3.12.1'
    port '8081'
    env ['INSTALL4J_ADD_VM_PARAMS="-Xms512m -Xmx512m -XX:MaxDirectMemorySize=1g','-Djava.util.prefs.userRoot=/opt/sonatype-work/nexus3/user-root']
    volumes ['/opt/sonatype-work/nexus3:/nexus-data']
    network_mode 'host'
    action :run
end

# Jenkins Container
directory '/var/lib/jenkins' do
    action :create
end

directory '/home/vagrant/jenkins-container' do
    user 'vagrant'
    group 'vagrant'
end

docker_container 'jenkins' do
    repo 'agilityroots/jenkins'
    tag '1.0'
    volumes ['/var/lib/jenkins:/var/jenkins_home']
    port '8080'
    network_mode 'host'
    action :run
end