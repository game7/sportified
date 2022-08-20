class Ahoy::Store < Ahoy::DatabaseStore
end

module Ahoy
  def self.use_relative_model_naming?
    true
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

Ahoy.geocode = false

Ahoy.track_bots = false
