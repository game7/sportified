class Hockey::Goaltender < ActiveRecord::Base
  include Sportified::TenantScoped  
  belongs_to :player
end
