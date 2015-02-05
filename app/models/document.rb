class Document < Asset
  mount_uploader :file, DocumentUploader
end
