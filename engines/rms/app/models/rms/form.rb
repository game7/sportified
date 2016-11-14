module Rms
  class Form < ActiveRecord::Base
    include Sportified::TenantScoped
    belongs_to :tenant
  end
end
