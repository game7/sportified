class Sport
  include Mongoid::Document
  
  field :name
  key :name

  references_many :leagues

end
