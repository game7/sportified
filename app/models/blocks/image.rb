module Blocks
  class Image < Block
    
    before_save :format_link_url

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
    
    protected
    
    def format_link_url
      unless self.link_url && self.link_url.start_with?("http://")
        self.link_url = "http://#{self.link_url}"
      end
    end
    
  end
end