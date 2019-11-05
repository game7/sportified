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

class PostSerializer < ActiveModel::Serializer
  attributes :id, :summary, :body, :link_url, :thumb_url, :tag_list, :created_at, :updated_at
  def thumb_url
    object.image.thumb.url if object.image_url.present?
  end
end
