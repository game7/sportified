module Rms
  class ApplicationController < Rms.configuration.base_controller.constantize
    protect_from_forgery with: :exception
    layout 'application'
  end
end
