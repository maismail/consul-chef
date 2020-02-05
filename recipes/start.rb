case node["platform_family"]
when "debian"
    service_target = "/lib/systemd/system/consul.service"
when "rhel"
    service_target = "/usr/lib/systemd/system/consul.service"
end

if node['consul']['bind_address'].empty?
    bind_address = my_private_ip()
else
    bind_address = node['consul']['bind_address']
end

template service_target do
    source "init/consul.service.erb"
    owner 'root'
    group 'root'
    mode 0644
    variables({
        :bind_address => bind_address
    })
end

systemd_unit "consul.service" do
    action [:start]
end

if node['kagent']['enabled'].casecmp("true")
    kagent_config service_name do
      service "Consul"
    end
end

if node['services']['enabled'].casecmp("true")
    systemd_unit "consul.service" do
        action [:enable]
    end
end