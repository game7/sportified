module Blocks
  class Image < Block

    def self.actions 
      %w{ edit }
    end
    
    field :link_url 
    field :alignment
    field :height
    field :width
    mount_uploader :image, ImageUploader
    
    def self.alignment_options
      ["left","center","right"]
    end
    
  end
end