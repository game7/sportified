class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider
  field :uid

  embedded_in :user
  
end
