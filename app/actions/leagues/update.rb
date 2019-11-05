class Leagues::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :description])
    league = League::Program.find(@payload[:id])
    league.update! params
  end

end
