# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  page_id    :integer
#  type       :string(255)
#  section_id :integer
#  column     :integer
#  position   :integer
#  options    :hstore
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  file       :string(255)
#

module Blocks
  class Contact < Block
    
    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      first: :string,
      last: :string,
      title: :string,
      phone: :string,
      email: :string,
      show_email: :boolean
      
  end
end
