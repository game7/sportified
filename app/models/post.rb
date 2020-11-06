# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text
#  image      :string
#  link_url   :string
#  summary    :text
#  title      :string
#  created_at :datetime
#  updated_at :datetime
#  tenant_id  :integer
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
