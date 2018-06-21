#
# Cookbook:: pipeline-jumpstart-chef
# Spec:: docker
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pipeline-jumpstart-chef::default' do
    context "when the cookbook is installed" do
        let(:chef_run) do
            runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)        
        end
    
        it 'starts Docker service' do
            expect(chef_run).to start_docker_service('default')
        end

        it 'starts Docker service manager' do
            expect(chef_run).to start_docker_service_manager('default')
        end

        it  'creates Volumes for Nexus Container' do
            expect(chef_run).to create_directory('/opt/sonatype-work/data')
        end

        it 'creates volumes for Sonarqube' do
            expect(chef_run).to create_directory('/opt/sonarqube/conf')
            expect(chef_run).to create_directory('/opt/sonarqube/data')
            expect(chef_run).to create_directory('/opt/sonarqube/extensions')
            expect(chef_run).to create_directory('/opt/sonarqube/bundled-plugins')
        end

        it 'creates volumes for Jenkins' do
            expect(chef_run).to create_directory('/var/lib/jenkins')
        end

        it 'creates volumes for postgres' do
            expect(chef_run).to create_directory('/var/lib/postgres/data')
        end

        it 'creates docker-compose YML' do
            expect(chef_run).to create_template_if_missing('/opt/docker-compose.yml')
        end
    end
end