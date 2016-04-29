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
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#

module PostsHelper
end
