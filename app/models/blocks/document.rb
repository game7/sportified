module Blocks
  class Document < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      title: :string,
      description: :string
      
    mount_uploader :file, DocumentUploader
    
    def apply_mongo_file! mongo_file
    end
    
  end
end