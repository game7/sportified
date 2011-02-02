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

kings = season.teams.create :name => 'Kings'
ducks = season.teams.create :name => 'Ducks'
sharks = season.teams.create :name => 'Sharks'
stars = season.teams.create :name => 'Stars'
coyotes = season.teams.create :name => 'Coyotes'
avalanche = season.teams.create :name => 'Avalanche'

puts 'GENERATING GAMES'
game_times = [ DateTime.parse('10/07/10 7:30 pm'), DateTime.parse('10/07/10 9:00 pm'), DateTime.parse('10/07/10 10:30 pm') ]
teams = season.teams.all.entries
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
    g = season.games.build
    g.starts_on = game_times[game].advance(:days => @days_advance)
    g.left_team = GameTeam.new( :team => @left_team )
    g.right_team = GameTeam.new( :team => @right_team )
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
season.games.where(:starts_on.lt => DateTime.now).each do |game|
  game.result = GameResult.new(:game => game, :left_team_score => rand(8), :right_team_score => rand(8))
  game.result.save
end


