default['consul']['user']           = node['install']['user'].empty? ? 'consul' : node['install']['user']
default['consul']['group']          = node['install']['user'].empty? ? 'consul' : node['install']['user']
default['consul']["dir"]            = node['install']['dir'].empty? ? "/srv/hops" : node['install']['dir']
default['consul']['home']           = "#{node['consul']['dir']}/consul"

default['consul']['version']        = "1.6.3"
default['consul']['use_dnsmasq']    = "true"