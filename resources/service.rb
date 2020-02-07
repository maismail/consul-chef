actions :register

attribute :service_definition, :kind_of => String, :required => true
attribute :template_variables, :kind_of => Hash, :required => false, default: {}