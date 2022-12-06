# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  column     :integer
#  file       :string
#  options    :hstore
#  position   :integer
#  type       :string
#  created_at :datetime
#  updated_at :datetime
#  page_id    :integer
#  section_id :integer
#
module Blocks
  class Carousel < Block
    def self.actions
      %w[edit]
    end

    store_accessor :options, :post_count, :shuffle, :interval, :tags

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

    def shuffle
      super == 1
    end

    def interval=(count)
      super(count.to_i)
    end

    def interval
      [super.to_i, 3].max
    end

    def posts
      posts = Post.includes(:tenant)
                  .tagged_with(tags, any: true)
                  .where('image IS NOT NULL')
                  .limit(post_count)
      shuffle ? posts.random : posts.newest
    end

    validates :post_count, numericality: { only_integer: true }
    validates :interval, numericality: { only_integer: true }
  end
end
