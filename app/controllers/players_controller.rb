# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string
#  last_name     :string
#  jersey_number :string
#  birthdate     :date
#  email         :string
#  slug          :string
#  mongo_id      :string
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#  position      :string
#

class PlayersController < BaseLeagueController

  def index
    render locals: {
      players: players,
      season_options: season_options
    }
  end

  def show
    player = Player.find(params[:id])
    render locals: {
      player: player,
      skater_stats: Hockey::Skater::Result.where('player_id = ?', player.id).includes(:game, :team).order('events.starts_on'),
      goalie_stats: Hockey::Goaltender::Result.where('player_id = ?', player.id).includes(:game, :team).order('events.starts_on')
    }
  end

  def career
    player = Player.find(params[:id])
    skater_records = Hockey::Skater::Record.joins(player: { team: [ :season, :division ]})
                                           .where('players.email = ?', player.email)
                                           .order('league_seasons.starts_on')
                                           .includes(:player)
                    #.order_by_season
    render locals: {
      skater_records: skater_records,
      player: player
    }
  end

  private

    def players
      Player.joins(:team)
            .includes(:team)
            .where('league_teams.season_id = ? AND league_teams.division_id = ?', @season.id, @division.id)
            .order(last_name: :asc)
    end

    def season_options
      @division.seasons.all
                       .order(starts_on: :desc)
                       .collect{|s| [s.name, league_players_path(@program.slug, @division.slug, s.slug)]}
    end

end
