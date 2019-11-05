class Seasons::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Season.find(@payload[:id])
  end

end
