class Api::League::PlayersController < Api::BaseController

  def batch_create

    Chronic.time_class = Time.zone
    params[:player].each do |game|
      game[:birthdate] = Chronic.parse(game[:birthdate])
    end

    begin
      players = ::Player.create! players_params[:player]
      render json: players
    rescue => ex
      render json: ex.to_s, status: 400
    end

  end

  private

  def players_params
    params.permit(player: [ :team_id, :first_name, :last_name, :jersey_number,
      :email, :birthdate, :position, :substitute]
    )
  end

end
