#
# Cookbook:: pipeline-jumpstart-chef
# Spec:: recipe_include
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pipeline-jumpstart-chef::default' do
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