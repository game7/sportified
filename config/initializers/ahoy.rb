class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    data[:ip] = request.env['HTTP_CF_CONNECTING_IP'] || request.remote_ip
    super(data)
  end
end

module Ahoy
  def self.use_relative_model_naming?
    true
  end
end

# set to true for JavaScript tracking
Ahoy.api = false

Ahoy.track_bots = false
