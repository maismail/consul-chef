name 'consul'
maintainer 'Antonios Kouzoupis'
maintainer_email 'antonios@logicalclocks.com'
license 'Apache License Version 2.0'
description 'Installs/Configures HashiCorp Consul'
long_description 'Installs/Configures HashiCorp Consul for Hopsworks'
source_url 'https://github.com/logicalclocks/consul-chef'
issues_url 'https://github.com/logicalclocks/consul-chef/issues'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'conda'