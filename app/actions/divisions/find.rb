class Divisions::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Division.find(@payload[:id])
  end

end
