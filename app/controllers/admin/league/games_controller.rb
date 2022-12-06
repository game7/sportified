class Admin::League::GamesController < Admin::AdminController
  skip_before_action :verify_admin, only: [:index]
  before_action :verify_admin_or_operations, only: [:index]
  before_action :mark_return_point, only: %i[new edit]
  before_action :load_event, only: %i[edit update]

  def index
    add_breadcrumb 'Games', admin_league_games_path
    @games = ::League::Game.before(1.day.from_now)
                           .includes(:division)
                           .order(starts_on: :desc)
                           .page(params[:page])
  end

  def new
    if params[:clone]
      clone = ::League::Game.find(params[:clone])
      @game = clone.dup
      load_options
    else
      load_options
      @game = ::League::Game.new
      @game.program_id = @options[:programs].first.id if @options[:programs].length == 1
      @game.location_id = @options[:locations].first.id if @options[:locations].length == 1
    end
  end

  def create
    Chronic.time_class = Time.zone
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    @game = ::League::Game.new(game_params)
    if @game.save
      return_to_last_point success: 'Game was successfully created.'
    else
      puts @game.errors.messages
      flash[:error] = 'Game could not be created.'
      load_options
      render action: 'new'
    end
  end

  def edit
    load_options
  end

  def update
    @game = ::League::Game.find(params[:id])
    Chronic.time_class = Time.zone
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    if @game.update_attributes(game_params)
      return_to_last_point(notice: 'Game was successfully updated.')
    else
      flash[:error] = 'Game could not be updated.'
      load_options
      render action: 'edit'
    end
  end

  private

  def game_params
    params.require(:game).permit(:program_id, :season_id, :division_id, :starts_on, :duration,
                                 :location_id, :summary, :description, :show_for_all_teams,
                                 :away_team_id, :away_team_custom_name, :away_team_name,
                                 :home_team_id, :home_team_custom_name, :home_team_name,
                                 :text_before, :text_after, :show_for_all_teams,
                                 :away_team_score, :home_team_score, :completion, :result,
                                 :playing_surface_id, :home_team_locker_room_id, :away_team_locker_room_id)
  end

  def load_options
    @options = {
      programs: ::League::Program.order(:name).select(:id, :name),
      divisions: ::League::Division.order(:name).select(:id, :name, :program_id).group_by { |d| d.program_id },
      seasons: ::League::Season.order(starts_on: :desc).select(:id, :name, :program_id).group_by { |s| s.program_id },
      locations: Location.order(:name).select(:id, :name),
      playing_surfaces: PlayingSurface.order(:name).select(:id, :name, :location_id).group_by { |ps| ps.location_id },
      locker_rooms: LockerRoom.order(:name).select(:id, :name, :location_id).group_by { |ps| ps.location_id },
      teams: @game ? ::League::Team.for_division(@game.division).for_season(@game.season).order(:name) : []
    }
  end

  def load_event
    @game = ::League::Game.find(params[:id])
  end
end
