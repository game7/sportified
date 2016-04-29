# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#  file       :string
#

module Blocks
  class Image < Block
    
    before_save :format_link_url

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      link_url: :string,
      alignment: :string,
      height: :string,
      width: :string

    mount_uploader :file, ImageUploader
    
    def apply_mongo_file! mongo_file
    end    
    
    def self.alignment_options
      ["left","center","right"]
    end
    
    def apply_mongo!(mongo)
      if mongo['image'] && !self.file.url && self.tenant
        self.remote_file_url = "https://sportified.s3.amazonaws.com/uploads/#{self.tenant.slug}/pages/#{self.page.mongo_id}/images/" + mongo['image']
      end
    end
    
    protected
    
    def format_link_url
      unless self.link_url && self.link_url.start_with?("http://")
        self.link_url = "http://#{self.link_url}"
      end
    end
    
  end
end
