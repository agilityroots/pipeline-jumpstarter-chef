name 'docker_pipeline_jumpstart'
maintainer 'Agility Roots'
maintainer_email 'hack@agilityroots.com'
license 'Apache-2.0'
description 'Installs/Configures docker_pipeline_jumpstart'
long_description 'Installs/Configures docker_pipeline_jumpstart'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/docker_pipeline_jumpstart/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/docker_pipeline_jumpstart'

depends 'java', '~> 2.1.0'
depends 'chef-sugar', '~> 4.0.0'
depends 'chef-apt-docker', '~> 2.0.6'
depends 'docker', '~> 4.2.0'
