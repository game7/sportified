module Blocks
  class Carousel < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      post_count: :integer,
      shuffle: :boolean,
      title: :string,
      phone: :string,
      email: :string,
      show_email: :boolean,
      tags: :array
    
    def posts
      Post.tagged_with_any(self.tags).where(:image.exists => true).newest_first.limit(self.post_count)
    end
    
  end
end