template "#{node['consul']['conf_dir']}/consul.hcl" do
    source "config/master.hcl.erb"
    owner node['consul']['user']
    group node['consul']['group']
    mode 0750
end

include_recipe "consul::start"