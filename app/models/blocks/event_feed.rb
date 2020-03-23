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
#  created_at :datetime
#  updated_at :datetime
#  file       :string
#

module Blocks
  class EventFeed < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, %i( title tags event_count )

    def tags=(array)
      super(array.join('||'))
    end

    def tags
      super&.split('||')&.reject{|s| s&.strip.empty? }
    end

    def events
      ::Event.public_only.tagged_with(tags, any: true).in_the_future.limit(event_count)
    end

  end
end
