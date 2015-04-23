module Admin::HockeyStatsheetsHelper
  
  def format_player_name(record)
    "#{record.player.jersey_number} - #{record.player.last_name}" if record && record.player
  end
  
end