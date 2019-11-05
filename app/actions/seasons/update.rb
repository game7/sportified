class Seasons::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :starts_on, :division_ids => []])
    league = League::Season.find(@payload[:id])
    league.update! params
  end

end
