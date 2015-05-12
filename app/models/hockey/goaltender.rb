class Hockey::Goaltender < ActiveRecord::Base
  include Sportified::TenantScoped  
  belongs_to :player, class_name: '::Player'
end
