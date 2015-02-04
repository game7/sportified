module Blocks
  class Document < Block

    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      title: :string,
      description: :string,
      file: :string

    mount_uploader :file, DocumentUploader
    
  end
end