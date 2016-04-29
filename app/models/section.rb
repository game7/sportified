# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  pattern    :string
#  position   :integer
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#

class Section < ActiveRecord::Base

    belongs_to :page
    
    PATTERNS = [
      "100", 
      "50|50",
      "33|66",
      "66|33",
      "25|75",
      "75|25",
      "33|33|33",
      "25|50|25",
      "50|25|25",
      "25|25|50",
      "25|25|25|25"
    ]

    def self.patterns
      @patterns ||= PATTERNS
    end    
    
    def columns
      @columns ||= pattern.split("|")
    end
    
    after_destroy do |section|
      section.page.blocks.where(section_id: section.id).destroy_all
    end
    
end
