require_dependency "rms/application_controller"

module Rms
  class VariantsController < ApplicationController
    before_action :verify_user

    def register
      registration = variant.registrations.build
      registration.user = current_user
      registration.email = current_user.email
      puts variant.item.form_packet
      variant.form_packet.templates.each do |template|
        registration.forms.build({ template: template, registration: registration })
      end if variant.form_packet
      if registration.save
        redirect_to checkout_registration_path registration
      else
        flash[:error] = "unable to register: #{registration.errors.messages}"
        if referer = request.headers["Referer"]
          redirect_to referer
        else
          redirect_to items_path
        end
      end
    end

    private

      def variant
        Variant.find(params[:id])
      end

  end
end
