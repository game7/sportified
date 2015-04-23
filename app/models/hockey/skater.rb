class Hockey::Skater < ActiveRecord::Base
  include Sportified::TenantScoped
  belongs_to :player, :class_name => '::Player'
end
