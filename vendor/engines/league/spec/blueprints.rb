require 'sham'
require 'faker'

Sham.name { Faker::Company.name }
Sham.host { Faker::Internet.domain_name }
Sham.first { Faker::Name.first_name }
Sham.last { Faker::Name.last_name }

Site.blueprint do
  name { Sham.name }
  host { Sham.host }  
end

Division.blueprint do
  name { Sham.name }
  site { Site.make }
end

StandingsLayout.blueprint do
  name { Sham.name }
  site { Site.make }
end

StandingsColumn.blueprint do
  title { Sham.name }
  field_name { Sham.name }
  description { Faker::Lorem.words }
end

Season.blueprint do
  name { Sham.name }
  starts_on { 1.day.ago }
  site { Site.make }
end

Team.blueprint do
  name { Sham.name }
  division { Division.make }
  season { Season.make }
  site { Site.make }
end

Club.blueprint do
  name { Sham.name }
  site { Site.make }
end


Venue.blueprint do
  name { Sham.name }
  site { Site.make }
end

Player.blueprint do
  first_name { Sham.first }
  last_name { Sham.last }
  jersey_number { rand(50) }
end

Event.blueprint do
  season { Season.make }
  starts_on { DateTime.now }
  duration { 90 }
  site { Site.make }
end

Game.blueprint do
  season { Season.make }
  starts_on { DateTime.now }
  duration { 90 }
  left_team { Team.make }
  right_team { Team.make }
  site { Site.make }
end

GameUpload.blueprint do
end

HockeyGoal.blueprint do
  per { rand(3) }
  min { rand(15) }
  sec { rand(60) }
  side { 'left' }
  plr { rand(29) }
  a1 { rand(29) }
  a2 { rand(29) }
  str { 'EV' }
end

HockeyPenalty.blueprint do
  per { rand(3) }
  min { rand(15) }
  sec { rand(60) }
  side { 'left' }
  plr { rand(29) }
  dur { 2 }
  inf { HockeyPenalty.infractions[rand(10)] }
  severity { 'minor' }  
end

HockeyPlayer.blueprint do
  num { rand(29) }
  name { Sham.name }
end

  
