class Locations::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Location.find(@payload[:id])
  end

end
