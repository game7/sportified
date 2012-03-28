module Blocks
  class Image < Block

    field :link_url 
    field :alignment
    field :height
    field :width
    mount_uploader :image, ImageUploader
    
    def self.alignment_options
      ["Left","Center","Right"]
    end
    
  end
end