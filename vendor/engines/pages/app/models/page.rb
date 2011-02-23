class Page
  include Mongoid::Document
  cache

  field :title 
  validates_presence_of :title

end
