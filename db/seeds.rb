# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name == 'system.indexes' }.each(&:drop)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'First User', :email => 'first_user@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name

puts 'SETTING UP DEMO LEAGUE'
division = Division.create! :name => 'Advanced'
season = division.seasons.build :name => 'Winter 2011', :starts_on => '1/1/2011', :ends_on => '4/1/2011'
season.save
kings = season.teams.build :name => 'Kings'
kings.save
ducks = season.teams.build :name => 'Ducks'
ducks.save
sharks = season.teams.build :name => 'Sharks'
sharks.save
stars = season.teams.build :name => 'Stars'
stars.save



