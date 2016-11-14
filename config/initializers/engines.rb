
require 'rms'

Rms.configure do |config|
  config.base_controller = "ApplicationController"
  config.stripe_public_key = ENV['STRIPE_PUBLIC_KEY']
  config.stripe_private_key = ENV['STRIPE_SECRET_KEY']
end
