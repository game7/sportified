class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Traversal
  include Mongoid::Tree::Ordering
  include Sportified::TenantScoped
  
  field :title 
  validates_presence_of :title
  
end
