require 'sham'
require 'faker'

Sham.name { Faker::Company.name }
Sham.host { Faker::Internet.domain_name }
Sham.name { Faker::Name.name }

Site.blueprint do
  name { Sham.name }
  host { Sham.host }
end

Page.blueprint do
  title { Sham.name }
  site { Site.make }
  position { 1 }
end

Block.blueprint do
  title { Sham.name }
end

