class Divisions::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :description])
    league = League::Division.find(@payload[:id])
    league.update! params
  end

end
