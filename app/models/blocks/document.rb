module Blocks
  class Document < Block

    field :title
    field :description
    mount_uploader :file, DocumentUploader
    
  end
end