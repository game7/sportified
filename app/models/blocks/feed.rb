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
  class Feed < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :post_count,
                             :tags

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
