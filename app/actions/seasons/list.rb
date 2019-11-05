class Seasons::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    League::Season.all.order(:name)
  end

end
