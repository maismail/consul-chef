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
depends 'kagent'

attribute "consul/user",
          :description => "System user to run the service",
          :type => 'string'

attribute "consul/group",
          :description => "Group id of consul user",
          :type => 'string'

attribute "consul/version",
          :description => "Version of Consul to install",
          :type => 'string'

attribute "consul/use_dnsmasq",
          :description => "Flag to control installation of dnsmasq. If set to false, DNS service discovery will NOT work",
          :type => 'string'

attribute "consul/configure_resolv_conf",
          :description => "Let cookbook configure dnsmasq resolv.conf",
          :type => 'string'

attribute "consul/bind_address",
          :description => "IP address Consul agent will bind to. You can also set a go-sockaddr template. Check https://www.consul.io/docs/agent/options.html#_bind for more information.",
          :type => 'string'

attribute "consul/master/bootstrap_expect",
          :description => "Number of Consul masters to wait before it starts serving requests",
          :type => 'string'

attribute "consul/master/ui",
          :description => "Flag to enable/disable the web UI",
          :type => 'string'