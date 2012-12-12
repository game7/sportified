module Blocks
  class Document < Block

    def self.actions 
      %w{ edit }
    end

    field :title
    field :description
    mount_uploader :file, DocumentUploader
    
  end
end