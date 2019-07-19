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

  end
end
