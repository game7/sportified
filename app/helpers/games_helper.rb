module GamesHelper
  
  def show_player_name(statsheet, side, num)
    players = statsheet.players.with_num(num)
    plr =  side == 'away' ? players.away.first : players.home.first
    plr ? plr.name : ''
  end

end
