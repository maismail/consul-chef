masters = private_recipe_ips("consul", "master")

template "#{node['consul']['conf_dir']}/consul.hcl" do
    source "config/slave.hcl.erb"
    owner node['consul']['user']
    group node['consul']['group']
    mode 0750
    variables({
        :masters => masters
    })
end

include_recipe "consul::start"