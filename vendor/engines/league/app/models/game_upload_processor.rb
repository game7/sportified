require 'csv'

class GameUploadProcessor
   
  def initialize(upload)
    @games = []
    @upload = upload
  end
  
  def build_games!
    puts "the columns are #{@upload.columns.join('|')}"
    rows = CSV.parse(open(@upload.file.url).read)
    rows.shift #drop title row
    rows.each do |row|
      g = Game.new(:site => Site.current)
      g.season_id = @upload.season_id
      g.starts_on = "#{get_column(:date, row)} #{get_column(:time, row)}"
      g.duration = get_column(:duration, row)
      g.left_team_id = get_column(:left_team, row)
      g.right_team_id = get_column(:right_team, row)
      if left_score = get_column(:left_score, row)
        if right_score = get_column(:right_score, row)
          puts "==> LEFT: #{left_score}, RIGHT: #{right_score}"
          g.left_team_score = left_score
          g.right_team_score = right_score
          g.completed_in = get_column(:completed_in, row)
        end
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
      g.finalize! if g.has_result?
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
      puts "   and the result is: #{val}"
      case label
        when :left_team
          @upload.find_team_id(val)
        when :right_team
          @upload.find_team_id(val)
        when :venue
          @upload.find_venue_id(val)
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
