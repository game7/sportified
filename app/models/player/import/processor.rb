require 'chronic'

class Player::Import::Processor
   
  def initialize(import)
    @players = []
    @import = import
  end
  
  def build_players!
    @import.contents.each_with_index do |row, i|
      next if i == 0
      p = Player.new
      p.team_id = get_column(:team, row)      
      p.first_name = get_column(:first_name, row)
      p.last_name = get_column(:last_name, row)
      p.jersey_number = get_column(:jersey_num, row)
      p.birthdate = Chronic.parse get_column(:birthdate, row)
      p.email = get_column(:email, row)
      @players << p
    end
  end

  def players
    @players
  end

  def complete!
    @players.each{|p| p.save }
    @import.completed = true
    @import.save
  end

  private

    def get_column(label, row)
      i = @import.columns.index(label)
      puts "- Get column labeled: #{label}"
      puts "   which should be at position #{i}"
      puts "   from row with: #{row.join('|')}"
      return unless i
      val = row[i]
      puts "   and the result is: #{val}"
      case label
        when :first_name, :last_name
          val = val.humanize if val and val == val.upcase
          val
        when :email
          val.downcase if val
        when :team
          @import.find_team_id(val)
        else
          val
      end
    end

end
