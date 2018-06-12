# Java Attributes
override['java']['jdk_version'] = '8'
override['java']['install_flavor'] = 'oracle'
override['java']['oracle']['accept_oracle_download_terms'] = true
# Nexus Attributes
override['nexus3']['url'] = 'http://download.sonatype.com/nexus/3/nexus-3.12.1-01-unix.tar.gz'
override['nexus3']['properties_variables'] = { host: '0.0.0.0', port: '8081', args: '${jetty.etc}/jetty.xml,${jetty.etc}/jetty-http.xml,${jetty.etc}/jetty-requestlog.xml', context_path: '/nexus/' }
# Jenkins Attributes
override['jenkins']['master']['install_method'] = 'package'
override['jenkins']['master']['jvm_options'] = '-Djenkins.install.runSetupWizard=false'