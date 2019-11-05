# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  pattern    :string
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_sections_on_page_id  (page_id)
#

class SectionSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :pattern, :position, :created_at, :updated_at
  attribute :blocks#, if: -> { object.blocks.loaded? }

  def blocks
    object.blocks.map do |block|
      ActiveModelSerializers::SerializableResource.new(block, adapter: :attributes)
    end
  end
end
