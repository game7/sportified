# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
today = Date.today

puts 'EMPTY THE MONGODB DATABASE'
Mongoid.purge!

puts 'TENANT'
Tenant.current = Tenant.create!(:name => 'Sportified Test', :host => 'localhost', :theme => 'oia', :link_url => '')

puts 'PAGE'
Page.create!(:title => "Welcome", :show_in_menu => false)

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Test User', :email => 'test@test.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
admin = User.create! :name => 'Admin User', :email => 'admin@admin.com', :password => 'please', :password_confirmation => 'please'
admin.roles << UserRole.super_admin
admin.save
puts 'New user created: ' << admin.name

puts ''
puts 'SETTING UP DEMO LEAGUE'
puts ''

puts '1 - Create Divisions'
%w{A B C}.each{|d| Division.create!(:name => d)}

puts ''
puts '2 - Create Seasons'
(today.prev_year.year..today.next_year.year).each do |s|
  season = Season.new( :name => s.to_s, :starts_on => '1/1/' + s.to_s)
  Division.all.each do |division|
    season.division_ids << division.id
    division.season_ids << season.id
    division.save
  end
  season.save
end

first_names = %w{Mario Shane John Patrik Sergei Luc Sydney PJ Travis Mike Henrik }
last_names = %w{Lemieux Doan Tonelli Stefan Fedorov Robitaille Crosby Stock Roy Smith Lundqvist }

puts ''
puts '3 - Create Teams'
division = Division.with_slug('a').first
%w{Kings Ducks Sharks Stars Coyotes Avalanche}.each do |t|
  Season.all.each do |s|
    team = division.teams.build :name => t, :season => s
    team.save
    (1..10).each do
      team.players.create!(:first_name => first_names[Random.rand(first_names.size)], :last_name => last_names[Random.rand(last_names.size)], :jersey_number => (Random.rand(98)+1).to_s)
    end
  end
end

season = Season.all.entries[1]
puts 'GENERATING GAMES FOR ' + division.name + ' ' + season.name
game_date = today.advance(:weeks => -10)
game_times = ['7:30 pm', '9:00 pm', '10:30 pm']
teams = division.teams.for_season(season).entries
team_count = teams.count
rounds = 20
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
    puts ' - build game...'
    g = Game.new
    g.division = division
    g.season = season
    g.starts_on = DateTime.parse(game_date.to_s + " " + game_times[game])
    g.home_team = @left_team
    g.away_team = @right_team
    puts ' - save... '
    g.save
    # lets post result if game in past
    if (game_date < DateTime.now)
      g.build_result(:home_score => rand(8), :away_score => rand(8), :completed_in => 'regulation')
      g.save
    end
  end
  #shift teams
  @a = teams.shift
  @b = teams.shift
  teams.push @b
  teams.unshift @a
  #shit times
  @a = game_times.shift
  game_times.push @a
  game_date = game_date.advance(:weeks => 1)
end



