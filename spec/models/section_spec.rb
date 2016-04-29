# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  pattern    :string
#  position   :integer
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Section, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
