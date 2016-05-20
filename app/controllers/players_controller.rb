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
  before_filter :get_season_options, :only => [:index]

  def index

    @players = Player.joins(:team).includes(:team).where('league_teams.season_id = ? AND league_teams.division_id = ?', @season.id, @division.id).order(last_name: :asc)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  def show

    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @player }
    end

  end

  private

  def get_season_options
    @season_options = @division.seasons.all.order(starts_on: :desc).collect{|s| [s.name, league_players_path(@program.slug, @division.slug, s.slug)]}
  end

end
