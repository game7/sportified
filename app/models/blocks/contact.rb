module Blocks
  class Contact < Block
    field :first
    field :last
    field :title
    field :phone
    field :email
    field :show_email, :type => Boolean, :default => false
  end
end