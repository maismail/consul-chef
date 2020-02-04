group node['consul']['group'] do
    action :create
    not_if "getent group #{node['consul']['group']}"
    not_if { node['install']['external_users'].casecmp("true") == 0 }
end

user node['consul']['user'] do
    home node['consul']['home']
    gid node['consul']['group']
    system true
    shell "/bin/bash"
    manage_home false
    action :create
    not_if "getent passwd #{node['consul']['user']}"
    not_if { node['install']['external_users'].casecmp("true") == 0 }
end


## REMOVE
group "hadoop" do
    action :create
    not_if "getent group hadoop"
    not_if { node['install']['external_users'].casecmp("true") == 0 }
  end

## REMOVE
  user "hdfs" do
    home "/home/hdfs"
    gid "hadoop"
    system true
    shell "/bin/bash"
    manage_home true
    action :create
    not_if "getent passwd hdfs"
    not_if { node['install']['external_users'].casecmp("true") == 0 }
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

basename = File.basename(node['consul']['bin_url'])
cached_file = "#{Chef::Config['file_cache_path']}/#{basename}"
remote_file cached_file do
    user node['consul']['user']
    group node['consul']['group']
    source node['consul']['bin_url']
    mode 0500
    action :create
end

package "unzip"

bash "unzip Consul" do
    user node['consul']['user']
    group node['consul']['group']
    umask 227
    code <<-EOH
        set -e
        unzip #{cached_file} -d #{node['consul']['bin_dir']}
    EOH
end