class Divisions::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :description])
    League::Division.create! params
  end

end
