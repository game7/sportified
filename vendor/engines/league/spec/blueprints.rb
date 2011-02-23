require 'sham'
require 'faker'

Sham.name { Faker::Company.name }

Division.blueprint do
  name { Sham.name }
end

Season.blueprint do
  name { Sham.name }
  starts_on { 1.day.ago }
end

Team.blueprint do
  name { Sham.name }
  division { Division.make }
  season { Season.make }
end
