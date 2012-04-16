class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable  
  include Sportified::TenantScoped

  field :title
  field :summary
  field :body
  mount_uploader :image, ImageUploader
  
  scope :newest_first, desc(:created_at)

end
