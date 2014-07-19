class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable  
  include Sportified::TenantScoped
  
  paginates_per 10

  field :title
  field :summary
  field :body
  field :link_url
  mount_uploader :image, ImageUploader
  
  scope :newest_first, ->{ desc(:created_at) }

end
