# Install and configure dnsmasq
if node['consul']['use_dnsmasq'].casecmp("true")
    package 'dnsmasq'

    if node['consul']['configure_resolv_conf'].casecmp("true")
        # Disable systemd-resolved for Ubuntu
        case node["platform_family"]
        when "debian"
            bash "Effectively disable systemd-resolved" do
                user 'root'
                group 'root'
                code <<-EOH
                    echo "DNSStubListener=no" | sudo tee --append /etc/systemd/resolved.conf
                EOH
            end
            systemd_unit "systemd-resolved.service" do
                action [:restart]
            end
            if node['consul']['effective_resolv_conf'].empty?
                resolv_conf = "/var/run/systemd/resolve/resolv.conf"
            else
                resolv_conf = node['consul']['effective_resolv_conf']
            end
        when "rhel"
            directory "/var/run/dnsmasq" do
                owner 'root'
                group 'root'
                mode '755'
                action
            end
            if node['consul']['effective_resolv_conf'].empty?
                effective_resolv_conf = "/etc/resolv.conf"
            else
                effective_resolv_conf = node['consul']['effective_resolv_conf']
            end
            bash "copy resolv.conf to dnsmasq directory" do
                user 'root'
                group 'root'
                code <<-EOH
                    set -e
                    cp #{effective_resolv_conf} /var/run/dnsmasq
                EOH
            end
            resolv_conf = "/var/run/dnsmasq/resolv.conf"
        end

        file "/etc/dnsmasq.d/default" do
            owner 'root'
            group 'root'
            mode '0755'
            content "port=53\nresolv-file=#{resolv_conf}\nbind-interfaces\nlisten-address=127.0.0.1\nserver=/consul/127.0.0.1#8600"
        end

        bash "configure new resolv.conf" do
            user 'root'
            group 'root'
            code <<-EOH
                set -e
                rm -f /etc/resolv.conf
                echo "nameserver 127.0.0.1" > /etc/resolv.conf
                chmod 644 /etc/resolv.conf
            EOH
        end

        systemd_unit "dnsmasq.service" do
            action :restart
        end
    end
end

template "#{node['consul']['conf_dir']}/systemd_env_vars" do
    source "init/systemd_env_vars.erb"
    owner node['consul']['user']
    group node['consul']['group']
    mode 0750
end

bash "export security env variables for client" do
    user node['consul']['user']
    group node['consul']['group']
    cwd node['consul']['home']
    code <<-EOH
        echo "export CONSUL_CACERT=#{node["kagent"]["certs"]["root_ca"]}" >> .bashrc
        echo "export CONSUL_CLIENT_CERT=#{node["kagent"]["certs_dir"]}/pub.pem" >> .bashrc
        echo "export CONSUL_CLIENT_KEY=#{node["kagent"]["certs_dir"]}/priv.key" >> .bashrc
        echo "export CONSUL_HTTP_ADDR=https://127.0.0.1:#{node['consul']['http_api_port']}" >> .bashrc
        echo "export CONSUL_TLS_SERVER_NAME=$(hostname -A | tr -d '[:space:]')" >> .bashrc
    EOH
end
