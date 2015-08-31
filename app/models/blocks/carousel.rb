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
      posts = Post.tagged_with(self.tags, :any => true).where("image IS NOT NULL")
      posts = self.shuffle ? posts.randomize : posts.newest
      posts.limit(self.post_count)
    end
    
  end
end