module League::TeamsHelper

  def display_result(team, game)
    if game.has_result?
      result = TeamGameResult.new(:team => team, :game => game)
      result.decision.first.capitalize + ' ' + result.scored.to_s + '-' + result.allowed.to_s
    end
  end

end
