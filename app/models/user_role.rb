class UserRole
  include Mongoid::Document
 
  embedded_in :user
  field :name
  field :title
  field :site_id
  field :subject_id

  scope :find_by_name, lambda { |name| { :where => { :name => name.to_s } } }

end
