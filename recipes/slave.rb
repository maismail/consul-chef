include_recipe "consul::default"

if node['consul']['retry_join']['provider'].empty?
    masters = private_recipe_ips("consul", "master")
elsif not node['consul']['retry_join']['provider'].empty? and node['consul']['retry_join']['tag_key'].nil?
    masters = private_recipe_ips("consul", "master")
else
    masters = ["provider=#{node['consul']['retry_join']['provider'].strip} tag_key=#{node['consul']['retry_join']['tag_key'].strip} tag_value=#{node['consul']['retry_join']['tag_value'].strip}"]
end

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
