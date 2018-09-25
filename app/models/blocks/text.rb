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
  class Text < Block

    def self.actions
      %w{ edit }
    end

    keys = %i(title caption body use_markdown)

    store_accessor :options, keys

    alias_attribute(:use_markdown?, :use_markdown)

    def wrap_in_well?
      !use_markdown?
    end

  end
end
