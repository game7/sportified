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