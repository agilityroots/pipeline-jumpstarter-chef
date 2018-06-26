#
# Cookbook:: docker_pipeline_jumpstart
# Spec:: docker
#
# Copyright:: 2018, Agility Roots
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'docker_pipeline_jumpstart::default' do
    context "when the cookbook is installed it" do
        let(:chef_run) do
            runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)        
        end
        let(:execute_run) { chef_run.execute('install_docker_compose') }
        let(:docker_compose_command_file) { chef_run.file('/usr/local/bin/docker-compose') }
        let(:compose_template) { chef_run.template('add_docker_compose_yml') }

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
            expect(chef_run).to create_directory('/var/lib/jenkins').with(
                user: 1000,
                group: 1000
            )
        end

        it 'creates volumes for postgres' do
            expect(chef_run).to create_directory('/var/lib/postgresql/data')
        end

        it 'installs docker compose' do
            # Mock 
            allow(File).to receive(:exists?).with(anything).and_call_original
            allow(File).to receive(:exists?).with('/usr/local/bin/docker-compose').and_return false
            expect(chef_run).to run_execute('install_docker_compose')
            expect(execute_run).to notify('file[docker_compose_command_file]').immediately
        end

        it 'makes docker-compose download exectuable command' do
            expect(chef_run).to touch_file('docker_compose_command_file').with(
                user:   'root',
                group:  'root',
                mode: '0755'
            )
        end

        it 'notifies docker-compose template' do
            expect(docker_compose_command_file).to notify('template[add_docker_compose_yml]').immediately
            #expect(chef_run).to create_template('add_docker_compose_yml')
        end

        it 'notifies running docker-compose' do
            #expect(chef_run).to run_execute('start_docker_containers').with(user: 'root')
            expect(compose_template).to notify('execute[start_docker_containers]')
        end
    end
end