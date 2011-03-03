require 'sham'
require 'faker'

Sham.domain { Faker::Internet.domain_name }
Sham.name { Faker::Name.name }
Sham.email { Faker::Internet.email }

Site.blueprint do
  name { Sham.name }
  domain { Sham.domain }
end

User.blueprint do
  name { Sham.name }
  email { Sham.email }
end

SiteUser.blueprint do
  
end
