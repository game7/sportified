# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  column     :integer
#  file       :string
#  options    :hstore
#  position   :integer
#  type       :string
#  created_at :datetime
#  updated_at :datetime
#  page_id    :integer
#  section_id :integer
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
