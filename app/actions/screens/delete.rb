class Screens::Delete < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Chromecast.find(@payload[:id]).destroy
  end

end
