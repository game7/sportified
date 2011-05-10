class DocumentBlock < Block
  
  field :title
  mount_uploader :document, DocumentUploader

end
