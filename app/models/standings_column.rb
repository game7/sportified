class StandingsColumn
  include Mongoid::Document

  field :field_name
  field :title
  field :description
  field :order

  embedded_in :parent, :inverse_of => :standings_columns

end
