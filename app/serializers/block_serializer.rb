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

class BlockSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :type, :section_id, :column, :position, :options, :created_at, :updated_at
end
