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

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end
