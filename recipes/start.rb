## TODO Fix for Cloud
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
        :bind_address => my_private_ip()
    })
end

systemd_unit "consul.service" do
    action [:enable, :start]
end