# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  column     :integer
#  file       :string
#  options    :hstore
#  position   :integer
#  type       :string
#  created_at :datetime
#  updated_at :datetime
#  page_id    :integer
#  section_id :integer
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
