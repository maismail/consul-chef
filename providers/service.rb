action :register do
    basename = File.basename(new_resource.service_definition, ".erb")
    template "#{node['consul']['conf_dir']}/#{basename}" do
        source new_resource.service_definition
        owner node['consul']['user']
        group node['consul']['group']
        mode 0500
        notifies :reload, 'systemd_unit[consul.service]', :immediately
    end
end