class Seasons::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :description, :division_ids => []])
    League::Season.create! params
  end

end
