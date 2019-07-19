# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  created_at :datetime
#  updated_at :datetime
#  file       :string
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
