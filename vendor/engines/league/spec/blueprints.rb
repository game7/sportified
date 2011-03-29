require 'sham'
require 'faker'

Sham.name { Faker::Company.name }
Sham.host { Faker::Internet.domain_name }

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

Game.blueprint do
  season { Season.make }
  starts_on { DateTime.now }
  left_team { Team.make }
  right_team { Team.make }
  site { Site.make }
end

GameResult.blueprint do
  left_team_score { rand(5) }
  right_team_score { rand(5) }
end

HockeyGoal.blueprint do
  per { rand(3) }
  min { rand(15) }
  sec { rand(60) }
  side { 'L' }
  plr { rand(29) }
  a1 { rand(29) }
  a2 { rand(29) }
  str { 'EV' }
end
