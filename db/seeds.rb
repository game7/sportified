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

puts ''
puts 'SETTING UP DEMO LEAGUE'

puts ''
puts '1 - Create Divisions'
['A', 'B', 'C', 'O30'].each{|d| Division.create!(:name => d)}

puts ''
puts '2 - Create Seasons'
['2010', '2011'].each do |s|
  season = Season.new( :name => s, :starts_on => '1/1/' + s)
  Division.all.each do |d|
    season.divisions << d
    d.save
  end
  season.save
end

puts ''
puts '3 - Create Teams'
a = Division.with_slug('a').first
['Kings', 'Ducks', 'Sharks', 'Stars', 'Coyotes', 'Avalanche'].each do |t|
  Season.all.each do |s|
    team = a.teams.build :name => t
    team.season = s
    team.save
  end
end

division = Division.first
season = Season.first
puts 'GENERATING GAMES FOR ' + division.name + ' ' + season.name
game_times = [ DateTime.parse('10/07/10 7:30 pm'), DateTime.parse('10/07/10 9:00 pm'), DateTime.parse('10/07/10 10:30 pm') ]
teams = division.teams.for_season(season).entries
team_count = teams.count
rounds = 25
games_per_round = team_count / 2

puts '- ' << team_count.to_s << ' teams'
puts '- ' << rounds.to_s << ' rounds'

rounds.times do |round|
  puts '-- Round ' << round.to_s << ' --'
  games_per_round.times do |game|
    if round % 2 == 1
      @left_team = teams[0 + game]
      @right_team = teams[team_count - game - 1]
    else
      @right_team = teams[0 + game]
      @left_team = teams[team_count - game - 1]      
    end
    puts ' ' << @left_team.name << ' vs ' << @right_team.name
    @days_advance = round * 7
    puts ' - build game...'
    g = division.games.build
    g.season = season
    g.starts_on = game_times[game].advance(:days => @days_advance)
    g.left_team = @left_team
    g.right_team = @right_team
    puts ' - save... '
    g.save
  end
  #shift teams
  @a = teams.shift
  @b = teams.shift
  teams.push @b
  teams.unshift @a
  #shit times
  @a = game_times.shift
  game_times.push @a
end

puts 'POST SOME RESULTS GAMES'
division.games.for_season(season).in_the_past.each do |game|
  game.result = GameResult.new(:game => game, :left_team_score => rand(8), :right_team_score => rand(8))
  game.result.save
end


