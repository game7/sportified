class Panel
  include Mongoid::Document

  field :width, :type => Integer
  field :depth, :type => Integer, :default => 1

  embedded_in :layout
  embedded_in :parent, :class_name => "Panel"
  embeds_many :children, :class_name => "Panel"

end
