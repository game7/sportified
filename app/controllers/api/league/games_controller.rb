class Api::League::GamesController < Api::BaseController

  def batch_create
    puts params[:game]
    Chronic.time_class = Time.zone
    params[:game].each do |game|
      game[:starts_on] = Chronic.parse(game[:starts_on])
    end
    begin
      games = ::League::Game.create! games_params[:game]
      render json: games
    rescue => ex
      render json: ex, status: 400
    end
    # @game = ::League::Game.new(game_params)
    # if @game.save
    #   return_to_last_point :success => 'Game was successfully created.'
    # else
    #   flash[:error] = 'Game could not be created.'
    #   load_options
    #   render :action => "new"
    # end
  end

  private

  def games_params
    params.permit(game: [ :program_id, :season_id, :division_id, :starts_on, :duration,
      :location_id, :away_team_id, :home_team_id ]
    )
  end

end
