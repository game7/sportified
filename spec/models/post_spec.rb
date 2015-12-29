# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  title      :string(255)
#  summary    :text
#  body       :text
#  link_url   :string(255)
#  image      :string(255)
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
