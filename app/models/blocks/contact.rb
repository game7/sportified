module Blocks
  class Contact < Block
    
    def self.actions 
      %w{ edit }
    end
    
    hstore_accessor :options,
      first: :string,
      last: :string,
      title: :string,
      phone: :string,
      email: :string,
      show_email: :boolean
      
  end
end