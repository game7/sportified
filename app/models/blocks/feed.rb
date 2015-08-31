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