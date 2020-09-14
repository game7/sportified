class Api::League::GamesController < Api::BaseController

  def batch_create

    Chronic.time_class = Time.zone
    params[:game].each do |game|
      game[:starts_on] = Chronic.parse(game[:starts_on])
    end

    begin
      games = ::League::Game.create! games_params[:game]
      render json: games
    rescue => ex
      puts games
      render json: ex, status: 400
    end

  end

  private

  def games_params
    params.permit(game: [ :program_id, :season_id, :division_id, :starts_on, :duration,
      :location_id, :away_team_id, :home_team_id, :text_before, :text_after ]
    )
  end

end
