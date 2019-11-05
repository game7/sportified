class Divisions::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Program.includes(:divisions).find(@payload[:league_id]).divisions
  end

end
