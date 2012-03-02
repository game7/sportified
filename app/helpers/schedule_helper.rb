module ScheduleHelper
  
  def get_rowspans(games)

    @rowspans = Array.new(@games.count)
    @row = 0
    games.each_with_index do |game, i|
      @current_date = game.starts_on.to_date
      if i == 0
        @span = 1
    elsif @current_date == @previous_date
        @span += 1
      else
        @rowspans[@row] = @span
        @row = i
        @span = 1
      end
      @previous_date = game.starts_on.to_date
    end  
    @rowspans[@row] = @span

    @rowspans
  
  end

end
