class Post < ActiveRecord::Base
  acts_as_taggable
  belongs_to :tenant
  
  paginates_per 10
  
  mount_uploader :image, ImageUploader
  
  scope :newest_first, ->{ desc(:created_at) }
    
end
