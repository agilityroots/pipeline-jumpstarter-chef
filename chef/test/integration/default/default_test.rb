# # encoding: utf-8

# Inspec test for recipe pipeline-jumpstart-chef::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# unless os.windows?
#   # This is an example test, replace with your own test.
#   describe user('root'), :skip do
#     it { should exist }
#   end
# end

describe command('java --version') do
  its('stdout') { should match /java 10/ }
end

describe package('jenkins') do
  it { should be_installed }
end

describe service('jenkins') do
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end

describe service('nexus') do
  it { should be_running }
end

describe port(8383) do
  it { should be_listening }
end