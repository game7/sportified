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
  class Text < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :title,
                             :caption,
                             :body

  end
end
