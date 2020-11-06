# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  pattern    :string
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#  page_id    :integer
#
# Indexes
#
#  index_sections_on_page_id  (page_id)
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
      # "33|33|33",
      "25|50|25",
      "50|25|25",
      "25|25|50",
      "25|25|25|25"
    ]

    def self.patterns
      PATTERNS
    end    
    
    def columns
      Section.to_word(pattern)
    end
    
    after_destroy do |section|
      section.page.blocks.where(section_id: section.id).destroy_all
    end

    def self.to_word(pattern)
      pattern.split("|").map do |column|
        {
          "100" => "sixteen",
          "75" => "twelve",
          "66" => "ten",
          "50" => "eight",
          "33" => "six",
          "25" => "four"
        }[column]
      end
    end
    
end
