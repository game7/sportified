require_dependency "rms/application_controller"

module Rms
  class AdminController < ApplicationController
    before_action :verify_admin
    layout 'client'
    def index
    end
  end
end
