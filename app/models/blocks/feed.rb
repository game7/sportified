module Blocks
  class Feed < Block

    def self.actions 
      %w{ edit }
    end

    field :post_count, :type => Integer, :default => 5
    field :tags, :type => Array, :default => []
    
    def posts
      Post.tagged_with_any(self.tags).newest_first.limit(self.post_count)
    end
    
  end
end