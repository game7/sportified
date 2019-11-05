class Locations::List < Action

  def initialize(payload)
    @payload = payload
  end

  def call
    Location.all.order(:name)
  end

end
