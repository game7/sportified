module Blocks
  class Contact < Block
    
    def self.actions 
      %w{ edit }
    end
      
    field :first
    field :last
    field :title
    field :phone
    field :email
    field :show_email, :type => Boolean, :default => false
  end
end