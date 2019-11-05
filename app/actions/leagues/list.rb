class Leagues::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Program.all.order(:name)
  end

end
