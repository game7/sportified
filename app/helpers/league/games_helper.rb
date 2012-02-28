module League::GamesHelper
  
  def show_player_name(statsheet, side, num)
    players = statsheet.players.with_num(num)
    plr =  side == 'left' ? players.left.first : players.right.first
    plr ? plr.name : ''
  end

end
