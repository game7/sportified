class Teams::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Team.find(@payload[:id])
  end

end
