#
# Cookbook:: docker_pipeline_jumpstart
# Spec:: default
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
    context 'When the cookbook is installed' do
        let(:chef_run) do
            runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)
        end

        # to mock
        # before do
        #     allow_any_instance_of(Chef::Recipe)
        #         .to receive(:include_recipe).with('java::default')
        #     allow_any_instance_of(Chef::Recipe)
        #         .to receive(:include_recipe).with('jenkins::master')       
        #     allow_any_instance_of(Chef::Recipe)         
        # end

        # or not to mock
        it 'includes the java cookbook' do
            expect(chef_run).to include_recipe('java::default')
        end
    end
end