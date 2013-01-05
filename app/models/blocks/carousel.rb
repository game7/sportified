module Blocks
  class Carousel < Block

    def self.actions 
      %w{ edit }
    end

    field :post_count, :type => Integer, :default => 5
    field :tags, :type => Array, :default => []
    
    def posts
      Post.tagged_with_any(self.tags)
    end
    
  end
end