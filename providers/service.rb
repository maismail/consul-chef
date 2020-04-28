action :register do
    basename = ::File.basename(new_resource.service_definition, ".erb")
    template "#{node['consul']['conf_dir']}/#{basename}" do
        source new_resource.service_definition
        owner node['consul']['user']
        group node['consul']['group']
        mode 0500
        variables new_resource.template_variables
    end

    systemd_unit "consul.service" do
        action :reload
        only_if { new_resource.reload_consul }
    end

    systemd_unit "consul.service" do
        action :restart
        only_if { new_resource.restart_consul }
    end
end
