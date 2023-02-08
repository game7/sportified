require 'csv'
require 'open-uri'

class Admin::GameImportsController < Admin::BaseLeagueController
  before_action :add_games_breadcrumb
  before_action :find_game_import, only: %i[edit update complete]
  before_action :load_season_options, only: [:new]
  before_action :load_division_options, only: [:new]
  before_action :load_team_options, only: %i[edit update]
  before_action :load_venue_options, only: %i[edit update]

  def new
    add_breadcrumb 'New'
    @game_import = Game::Import.new
  end

  def create
    contents = params.require(:game_import).permit(:contents)[:contents]
    contents = CSV.parse(contents.read) if contents
    @game_import = Game::Import.new(game_import_params)
    @game_import.contents = contents if contents
    if @game_import.save
      redirect_to edit_admin_game_import_path(@game_import.id), success: 'Game Upload has been created.'
    else
      flash[:error] = 'Game Upload could not be created.'
      find_season
      load_season_options
      load_division_options
      render action: 'new'
    end
  end

  def edit
    add_breadcrumb 'Edit'
    # set defaults
    @game_import.teams.each do |map|
      @team_options.each do |option|
        if map.team_id.nil? && (map.name.include? option[0] or option[0].include? map.name)
          map.team_id = option[1]
          break
        end
      end
    end
    @game_import.venues.each do |venue|
      venue.venue_id = @venue_options[0].id if @venue_options.count == 1 and venue.venue_id.nil?
    end
  end

  def update
    if @game_import.update(game_import_params)
      redirect_to admin_game_imports_path, notice: 'Game Upload was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def complete
    if @game_import.can_complete?
      processor = Game::Import::Processor.new(@game_import)
      processor.build_games!
      processor.complete!
      redirect_to admin_game_imports_path, success: "#{processor.games.length} Games have been successfully imported"
    else
      flash.now[:error] = 'Game Upload is not ready for completion'
      render action: 'index'
    end
  end

  def index
    @game_imports = Game::Import.desc(:created_at)
  end

  private

  def game_import_params
    params.require(:game_import).permit(:season_id, :division_id, teams_attributes: %i[id team_id],
                                                                  venues_attributes: %i[id venue_id])
  end

  def add_games_breadcrumb
    add_breadcrumb 'Events', admin_events_path
    add_breadcrumb 'Game Uploads', admin_game_imports_path
  end

  def find_game_import
    @game_import = Game::Import.find(params[:id])
  end

  def find_season
    @season = @game_import.season if @game_import
  end

  def load_season_options
    @season_options = Season.desc(:starts_on)
  end

  def load_division_options
    @division_options = []
    @division_options = @season.divisions.order(starts_on: :desc) if @season
  end

  def load_team_options
    @team_options = []
    return unless @game_import

    @team_options = Team.for_season(@game_import.season_id).for_division(@game_import.division_id).asc(:name).entries.collect do |team|
      [team.name, team.id]
    end
  end

  def load_venue_options
    @venue_options = Venue.asc(:name).entries
  end
end
