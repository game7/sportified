class Block
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :layout_id
  field :panel_id
  field :position, :type => Integer

  embedded_in :page

  def class_name
    self.class.to_s.titlecase
  end


end
