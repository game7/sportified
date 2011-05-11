class ImageBlock < Block
  
  field :link_url 
  field :image_height
  field :image_width
  mount_uploader :image, ImageUploader
  

end
