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
