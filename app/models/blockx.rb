require 'bson'

class Blockx
  include Mongoid::Document
  include Mongoid::Timestamps

  field :section_id, :type => BSON::ObjectId
  field :column, :default => 0, :type => Integer
  field :position, :type => Integer, :default => 0

  embedded_in :page
  
  def self.actions
    []
  end

  def class_name
    self.class.to_s.titlecase
  end  
  
  def friendly_name
    self.class.to_s.sub("Blocks::","").humanize
  end  
end
