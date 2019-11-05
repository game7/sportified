class Teams::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :short_name, :show_in_standings, :primary_color, :secondary_color, :accent_color, avatar: [ :data ]])
    team = League::Team.find(@payload[:id])
    team.update! params
  end

end
