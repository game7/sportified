# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  title      :string
#  summary    :text
#  body       :text
#  link_url   :string
#  image      :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_posts_on_tenant_id  (tenant_id)
#

require 'rails_helper'

RSpec.describe Post, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
