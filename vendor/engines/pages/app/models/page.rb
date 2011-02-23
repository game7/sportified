class Page
  include Mongoid::Document
  cache

  field :title 
  field :position, :type => Integer
  field :meta_keywords
  field :meta_description

  validates_presence_of :title
  validates_presence_of :position

end
