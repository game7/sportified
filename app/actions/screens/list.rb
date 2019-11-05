class Screens::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Chromecast.all.includes(:location).order(:name)
  end

end
