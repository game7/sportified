# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string(255)
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  file       :string(255)
#

require 'rails_helper'

RSpec.describe Block, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
