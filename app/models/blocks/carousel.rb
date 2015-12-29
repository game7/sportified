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
  class Carousel < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      post_count: :integer,
      shuffle: :boolean,
      tags: :array
    
    def posts
      posts = Post.tagged_with(self.tags, :any => true).where("image IS NOT NULL").newest.limit(self.post_count)
      self.shuffle ? posts.shuffle : posts
    end
    
  end
end
