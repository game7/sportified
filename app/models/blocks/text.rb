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

module Blocks
  class Text < Block
    
    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      title: :string,
      caption: :string,
      body: :string
    
  end
end
