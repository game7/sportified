require 'JSON'
module Blocks
  class Document < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      title: :string,
      description: :string
      
    mount_uploader :file, DocumentUploader
    
    def apply_mongo_file!(mongo)
      
    end
    
    def apply_mongo!(mongo)
      if mongo['file'] && !self.file.url
        p self.remote_file_url = "https://sportified.s3.amazonaws.com/uploads/#{self.tenant.slug}/pages/#{self.page.mongo_id}/documents/" + mongo['file']
      end
    end
    
  end
end