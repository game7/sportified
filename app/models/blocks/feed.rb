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
  class Feed < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      post_count: :integer,
      tags: :array
  
    def posts
      Post.tagged_with(self.tags, :any => true).newest_first.limit(self.post_count)
    end
    
  end
end
