class Screens::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :location_id])
    Chromecast.find(@payload[:id]).update!(params)
  end

end
