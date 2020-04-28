actions :register

attribute :service_definition, :kind_of => String, :required => true
attribute :template_variables, :kind_of => Hash, :required => false, default: {}
attribute :reload_consul, :kind_of => [TrueClass, FalseClass], :required => false, default: true
attribute :restart_consul, :kind_of => [TrueClass, FalseClass], :required => false, default: false
