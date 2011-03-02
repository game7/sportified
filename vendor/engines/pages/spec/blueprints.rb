require 'sham'
require 'faker'

Sham.name { Faker::Company.name }

Page.blueprint do
  title { Sham.name }
  position { 1 }
end

Block.blueprint do
  title { Sham.name }
end

