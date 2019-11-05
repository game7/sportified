class Locations::Create < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    params = @payload.permit(attributes: [:name, :short_name])
    Location.create! params
  end

end
