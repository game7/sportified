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

Game.blueprint do
  division { Division.make }
  season { Season.make }
  starts_on { DateTime.now }
  left_team { Team.make }
  right_team { Team.make }
end

GameResult.blueprint do
  left_team_score { rand(5) }
  right_team_score { rand(5) }
end
