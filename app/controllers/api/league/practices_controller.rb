class Api::League::PracticesController < Api::BaseController

  def batch_create
    Chronic.time_class = Time.zone
    params[:practice].each do |practice|
      practice[:starts_on] = Chronic.parse(practice[:starts_on])
    end

    begin
      practices = ::League::Practice.create! practices_params[:practice]
      render json: practices
    rescue => ex
      render json: ex, status: 400
    end

  end

  private

  def practices_params
    params.permit(practice: [ :program_id, :season_id, :division_id, :starts_on, :duration,
      :location_id, :away_team_id, :home_team_id, :text_before, :text_after ]
    )
  end

end
