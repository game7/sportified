require_dependency "rms/application_controller"

module Rms
  class Api::RegistrationsController < ApplicationController

    def show
      render json: Registration.find(params[:id])
    end

    def index
      render json: Registration.order(updated_at: :desc)
                               .limit(20)
                               .includes(:forms, :variant)
    end

  end
end
