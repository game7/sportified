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

class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
  end
end
