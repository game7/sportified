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
  
end
