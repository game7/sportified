class Locations::Update < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :short_name])
    location = Location.find(@payload[:id])
    location.update! params
  end

end
