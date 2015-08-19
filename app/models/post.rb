class Post < ActiveRecord::Base
  include Sportified::TenantScoped  
  acts_as_taggable
  belongs_to :tenant
  
  paginates_per 10
  
  mount_uploader :image, ImageUploader
  
  scope :newest_first, ->{ desc(:created_at) }
  
  def apply_mongo!(mongo)
    self.tag_list = mongo[:tags_array].join(',')
    if mongo['image'] && !self.image.url
      puts self.remote_image_url = "https://sportified.s3.amazonaws.com/uploads/#{self.tenant.slug}/posts/#{self.mongo_id}/images/" + mongo['image']
    end
  end
    
end
