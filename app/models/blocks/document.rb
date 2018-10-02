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

    store_accessor :options, :title,
                             :description

    mount_uploader :file, DocumentUploader

    def extension
      file&.file&.filename&.split('.')&.last
    end

    FILE_TYPES = {
      excel:      %w{xls xlsx},
      powerpoint: %w{ppt pptx},
      word:       %w{doc docx},
      pdf:        %w{pdf},
      video:      %w{mp4},
      audo:       %w{mp3},
      image:      %w{gif jpg jpeg svg}
    }

    def self.file_types
      FILE_TYPES
    end

    def icon
      result = 'file'
      FILE_TYPES.each{|key, value| result += "-#{key}" if value.include?(extension) }
      result
    end

    before_save :set_default_title

    def set_default_title
      self.title = self.file.filename if self.title.blank?
    end

  end
end
