module Blocks
  class Carousel < Block

    def self.actions 
      %w{ edit }
    end

    field :post_count, :type => Integer, :default => 5
    field :tags, :type => Array, :default => []
    field :shuffle, :type => Boolean, :default => false
    
    def posts
      Post.tagged_with_any(self.tags).where(:image.exists => true).newest_first.limit(self.post_count)
    end
    
  end
end