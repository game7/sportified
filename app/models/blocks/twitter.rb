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
  class Twitter < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :post_count,
                             :handles

    def tags=(array)
      super(array.join('||'))
    end

    def tags
      super&.split('||')
    end

    def posts
      Post.tagged_with(self.tags, :any => true).newest_first.limit(self.post_count)
    end

  end
end
