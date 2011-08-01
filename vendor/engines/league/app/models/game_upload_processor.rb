require 'csv'

class GameUploadProcessor
   
  def initialize(upload)
    @games = []
    @upload = upload
  end
  
  def build_games!
    puts "the columns are #{@upload.columns.join('|')}"
    rows = CSV.open(@upload.file.path, 'r')
    rows.shift #drop title row
    rows.each do |row|
      g = Game.new(:site => Site.current)
      g.season_id = @upload.season_id
      g.starts_on = "#{get_column(:date, row)} #{get_column(:time, row)}"
      g.duration = get_column(:duration, row)
      g.left_team_id = get_column(:left_team, row)
      g.right_team_id = get_column(:right_team, row)
      g.venue_id = get_column(:venue, row)
      @games << g
    end
  end

  def games
    @games
  end

  def complete!
    @games.each do |g|
      puts "  Errors: #{g.errors}" unless g.save
    end
    @upload.completed = true
    @upload.save
  end

  private

    def get_column(label, row)
      i = @upload.columns.index(label)
      puts "- Get column labeled: #{label}"
      puts "   which should be at position #{i}"
      puts "   from row with: #{row.join('|')}"
      val = row[i]
      case label
        when :left_team
          @upload.find_team_id(val)
        when :right_team
          @upload.find_team_id(val)
        when :venue
          @upload.find_venue_id(val)
        else
          val
      end
    end

end
