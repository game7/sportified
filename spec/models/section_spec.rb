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

require 'rails_helper'

RSpec.describe Section, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
