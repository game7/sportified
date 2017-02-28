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

    before_save :format_link_url

    def self.actions
      %w{ edit }
    end

    store_accessor :options, :link_url,
                              :alignment,
                              :height,
                              :width

    mount_uploader :file, ImageUploader


    def self.alignment_options
      ["left","center","right"]
    end

    protected

      def format_link_url
        unless self.link_url && self.link_url.start_with?("http://")
          self.link_url = "http://#{self.link_url}"
        end
      end

  end
end
