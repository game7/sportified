class Next::Admin::League::GamesController < Next::Admin::BaseController
  before_action :mark_return_point, only: %i[new edit]
  before_action :set_game, only: %i[edit update]

  def new
    @game = params[:clone] ? ::League::Game.find(params[:clone]).dup : ::League::Game.new

    inertia props: options.merge({
                                   game: @game
                                 })
  end

  def create
    if (@game = ::League::Game.new(game_params)).save
      return_to_last_point success: 'Game was successfully created.'
    else
      redirect_to new_next_admin_league_game_path, inertia: { errors: @game.errors },
                                                   error: 'Game could not be created.'
    end
  end

  def edit
    inertia props: options.merge({
                                   game: @game
                                 })
  end

  def update
    if @game.update(game_params)
      return_to_last_point notice: 'Game was successfully updated.'
    else
      redirect_to edit_next_admin_league_game_path(@game), inertia: { errors: @game.errors },
                                                           error: 'Game could not be updated.'
    end
  end

  private

  def game_params
    Chronic.time_class = Time.zone
    params[:game][:starts_on] = Chronic.parse(params[:game][:starts_on])
    params.require(:game).permit(:program_id, :season_id, :division_id, :starts_on, :duration,
                                 :location_id, :summary, :description, :show_for_all_teams,
                                 :away_team_id, :away_team_custom_name, :away_team_name,
                                 :home_team_id, :home_team_custom_name, :home_team_name,
                                 :text_before, :text_after, :show_for_all_teams,
                                 :away_team_score, :home_team_score, :completion, :result,
                                 :playing_surface_id, :home_team_locker_room_id, :away_team_locker_room_id)
  end

  def set_game
    @game = ::League::Game.find(params[:id])
  end

  def options
    @options ||= {
      programs: ::League::Program.order(:name).select(:id, :name),
      divisions: ::League::Division.order(:name).select(:id, :name, :program_id),
      seasons: ::League::Season.order(starts_on: :desc).select(:id, :name, :program_id),
      locations: Location.order(:name).select(:id, :name),
      playing_surfaces: PlayingSurface.order(:name).select(:id, :name, :location_id),
      locker_rooms: LockerRoom.order(:name).select(:id, :name, :location_id),
      teams: ::League::Team.order(:name).select(:id, :name, :season_id, :division_id)
    }
  end
end
