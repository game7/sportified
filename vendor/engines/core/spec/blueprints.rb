require 'sham'
require 'faker'

Sham.name { Faker::Company.name }

Site.blueprint do
  name { Sham.name }
end
