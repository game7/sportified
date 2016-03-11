module TeamsHelper
  
  def display_event_summary(event, team)
    event.class.to_s == "Game" && event.has_team?(@team) ? "#{event.home_team == @team ? 'vs' : 'at'} #{event.opponent_name(@team)}" : event.summary    
  end
  
  def display_time_or_result(event, team)
    if event.class.to_s == "Game" && event.has_result? && event.has_team?(team)
      display_result(event, team)
    else 
      event.all_day ? "All Day" : event.starts_on.strftime('%l:%M %p') 
    end
  end

  def display_result(game, team)
    if game.has_result?
      result = TeamGameResult.new(:team => team, :game => game)
      postfix = result.completed_in == 'shootout' ? " (SO)" : ""
      result.decision.first.capitalize + ' ' + result.scored.to_s + '-' + result.allowed.to_s + postfix
    end
  end

end
