class Leagues::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :description])
    League::Program.create! params
  end

end
