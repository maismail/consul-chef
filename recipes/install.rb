group node['consul']['group'] do
    action :create
    not_if "getent group #{node['consul']['group']}"
    not_if { node['install']['external_users'].casecmp("true") }
end

user node['consul']['user'] do
    home node['consul']['dir']
    gid node['consul']['group']
    system true
    shell "/bin/bash"
    manage_home false
    action :create
    not_if "getent passwd #{node['consul']['user']}"
    not_if { node['install']['external_users'].casecmp("true") }
end

directory node['consul']['dir']  do
    owner node['consul']['user']
    group node['consul']['group']
    mode "755"
    recursive true
    not_if { File.directory?("#{node["consul"]["dir"]}") }
end

directory node['consul']['home'] do
    owner node['consul']['user']
    group node['consul']['group']
    mode "750"
end

directory node['consul']['conf_dir'] do
    owner node['consul']['user']
    group node['consul']['group']
    mode "750"
end

directory node['consul']['data_dir'] do
    owner node['consul']['user']
    group node['consul']['group']
    mode "750"
end

directory node['consul']['bin_dir'] do
    owner node['consul']['user']
    group node['consul']['group']
    mode "750"
end

cached_file = "#{Chef::Config['file_cache_path']}/consul_#{node['consul']['version']}_linux_amd64.zip"
source = "#{node['download_url']}/consul/#{cached_file}"
remote_file cached_file do
    user node['consul']['user']
    group node['consul']['group']
    source source
    mode 0500
    action :create
end

bash "unzip Consul" do
    user node['consul']['user']
    group node['consul']['group']
    umask 227
    code <<-EOH
        set -e
        unzip #{cached_file} -d #{node['consul']['bin_dir']}
    EOH
end