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
  class Image < Block

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :link_url,
                              :alignment,
                              :height,
                              :width

    mount_uploader :file, ImageUploader


    def self.alignment_options
      %w{ left center right }
    end

  end
end
