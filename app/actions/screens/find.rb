class Screens::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Chromecast.find(@payload[:id])
  end

end
