class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field :title 
  field :position, :type => Integer
  field :meta_keywords
  field :meta_description

  embeds_many :blocks

  validates_presence_of :title
  validates_presence_of :position

end
