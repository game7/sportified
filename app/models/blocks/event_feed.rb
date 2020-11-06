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
      ::Event.public_only.tagged_with(tags, any: true).in_the_future.order(starts_on: :asc).limit(event_count)
    end

  end
end
