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
  
  def apply_mongo!(mongo)
    self.tag_list = mongo[:tags_array].join(',')
    if mongo['image'] && !self.image.url
      puts self.remote_image_url = "https://sportified.s3.amazonaws.com/uploads/#{self.tenant.slug}/posts/#{self.mongo_id}/images/" + mongo['image']
    end
  end
    
end
