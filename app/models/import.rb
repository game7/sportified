class Import
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sportified::TenantScoped
  
  field :contents, :type => Array
  validates_presence_of :contents
    
end
