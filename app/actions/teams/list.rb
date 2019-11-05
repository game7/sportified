class Teams::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    teams = League::Team.all
    teams = teams.where(season_id: @payload[:season_id]) if @payload[:season_id]
  end

end
