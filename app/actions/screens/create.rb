class Screens::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :location_id])
    Chromecast.create! params
  end

end
