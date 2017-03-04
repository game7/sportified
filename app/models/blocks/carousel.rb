# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#  file       :string
#

module Blocks
  class Carousel < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :post_count, :shuffle, :tags

    def post_count=(count)
      super(count.to_i)
    end

    def post_count
      super.to_i
    end

    def tags=(array)
      super(array.join('||'))
    end

    def tags
      super.split('||')
    end

    def posts
      posts = Post.tagged_with(self.tags, :any => true).where("image IS NOT NULL").newest.limit(self.post_count)
      !!self.shuffle ? posts.shuffle : posts
    end

  end
end
