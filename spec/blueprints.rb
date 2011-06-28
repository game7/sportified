require 'sham'
require 'faker'

Sham.host { Faker::Internet.domain_name }
Sham.name { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.password { 'pa$$w0rd' }

Site.blueprint do
  name { Sham.name }
  host { Sham.host }
end

User.blueprint do
  name { Sham.name }
  email { Sham.email }
  password { Sham.password }
end

UserRole.blueprint do
  name { "Role"}
end

