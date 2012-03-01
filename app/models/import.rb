class Import
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sportified::TenantScoped
  
  
end
