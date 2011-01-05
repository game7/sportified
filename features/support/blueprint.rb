require 'machinist/mongoid'

Division.blueprint do
  name { Faker::Company.name }
end
