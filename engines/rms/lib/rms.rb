require "rms/engine"
require "rms/configuration"

module Rms
  class << self
    attr_accessor :configuration
  end


  module_function
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end
end
