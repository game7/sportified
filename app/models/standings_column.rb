class StandingsColumn
  include Mongoid::Document

  field :field_name
  field :title
  field :description
  field :order

  embedded_in :parent, :inverse_of => :columns

  validates_presence_of :field_name, :title, :description

end
