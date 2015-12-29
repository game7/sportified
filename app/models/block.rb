# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string(255)
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  file       :string(255)
#

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
