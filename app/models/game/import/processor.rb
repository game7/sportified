require 'chronic'

class Game::Import::Processor
   
  def initialize(import)
    @games = []
    @import = import
  end
  
  def build_games!
    @import.contents.each_with_index do |row, i|
      next if i == 0
      g = Game.new
      g.season_id = @import.season_id
      g.league_id = @import.league_id
      g.starts_on = Chronic.parse "#{get_column(:date, row)} #{get_column(:time, row)}"
      g.duration = get_column(:duration, row)
      g.away_team_id = get_column(:away_team, row)
      g.home_team_id = get_column(:home_team, row)
      if completed_in = get_column(:completed_in, row) and away_score = get_column(:away_score, row) and home_score = get_column(:home_score, row)
        puts "==> AWAY: #{away_score}, HOME: #{home_score}"
        result = g.build_result
        result.away_score = away_score
        result.home_score = home_score
        result.completed_in = completed_in
      end
      g.venue_id = get_column(:venue, row)
      @games << g
    end
  end

  def games
    @games
  end

  def complete!
    @games.each do |g|
      g.save
    end
    @import.completed = true
    @import.save
  end

  private

    def get_column(label, row)
      i = @import.columns.index(label)
      return unless i
      val = row[i]
      case label
        when :away_team
          @import.find_team_id(val)
        when :home_team
          @import.find_team_id(val)
        when :venue
          @import.find_venue_id(val)
        when :completed_in
          case val
            when 'so', 'shootout'
              'shootout'
            when 'ot', 'overtime'
              'overtime'
            when 'fft', 'forfeit'
              'forfeit'
            when 'reg', 'regulation'
              'regulation'
            else
              val
          end
        else
          val
      end
    end

end
