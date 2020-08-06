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

class Post < ActiveRecord::Base
  include Sportified::TenantScoped  
  acts_as_taggable
  belongs_to :tenant
  
  paginates_per 10
  
  mount_uploader :image, ImageUploader
  
  scope :newest_first, ->{ order(created_at: :desc) }
  scope :newest, ->{ order(created_at: :desc) }
  scope :random, ->{ order(Arel.sql('RANDOM()')) }
    
end
