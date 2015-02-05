class Block < ActiveRecord::Base
  belongs_to :page
  
  def self.actions
    []
  end

  def class_name
    self.class.to_s.titlecase
  end  
  
  def friendly_name
    self.class.to_s.sub("Blocks::","").humanize
  end
  
  # this is a helper method for mongo to psql conversion
  # and can be removed after completion
  def tenant
    self.page.tenant
  end
  
end
