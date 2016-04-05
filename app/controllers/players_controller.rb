# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  team_id       :integer
#  first_name    :string(255)
#  last_name     :string(255)
#  jersey_number :string(255)
#  birthdate     :date
#  email         :string(255)
#  slug          :string(255)
#  mongo_id      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  substitute    :boolean
#

class PlayersController < BaseLeagueController
  before_filter :get_season_options, :only => [:index]

  def index

    @teams = @division.teams.for_season(@season)
    ids = @teams.collect{|team| team.id}
    @players = Player.joins(:team).where('teams.season_id = ?', @season.id).order(last_name: :asc)

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
    @season_options = @division.seasons.all.order(starts_on: :desc).collect{|s| [s.name, players_path(:division_slug => @division.slug, :season_slug => s.slug)]}
  end

end
