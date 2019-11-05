class Teams::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :short_name, :show_in_standings, :avatar])
    League::Team.create! params
  end

end
