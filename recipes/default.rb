# Install and configure dnsmasq
if node['consul']['use_dnsmasq'].casecmp("true")
    package 'dnsmasq'

    # Disable systemd-resolved for Ubuntu
    case node["platform_family"]
    when "debian"
        systemd_unit "systemd-resolved.service" do
            action [:stop, :disable]
        end
    when "rhel"
        directory "/var/run/dnsmasq" do
            owner 'root'
            group 'root'
            mode '755'
            action
        end
    end

    bash "copy resolv.conf to dnsmasq directory" do
        user 'root'
        group 'root'
        code <<-EOH
            set -e
            cp /etc/resolv.conf /var/run/dnsmasq
        EOH
    end

    ## NOTE: Do not attempt to fix the indentation.
    ## Tabs are also reflected in the file
    file "/etc/dnsmasq.d/default" do
        owner 'root'
        group 'root'
        mode '0755'
        content "
port=53
resolv-file=/var/run/dnsmasq/resolv.conf
bind-interfaces
listen-address=127.0.0.1
server=/consul/127.0.0.1#8600"
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
end