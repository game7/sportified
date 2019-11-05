class Leagues::Find < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    league = League::Program.includes(divisions: [:seasons], seasons: [:divisions]).find(@payload[:id])
  end

end
