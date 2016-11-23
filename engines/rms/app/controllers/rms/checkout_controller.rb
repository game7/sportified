require_dependency "rms/application_controller"

module Rms
  class CheckoutController < ApplicationController

    def redirect
      redirect_to_first_incomplete_form and return if registration.forms.incomplete.any?
      redirect_to_payment and return if registration.payment_required?
      redirect_to_confirmation
    end

    def form
      render locals: {
        registration: registration,
        form: get_form
      }
    end

    def form_post
      form = get_form
      form.completed = true
      if form.update(form_params(form))
        redirect_to checkout_registration_path
      else
        render :form, locals: {
          registration: registration,
          form: form
        }
      end
    end

    def payment
      render locals: {
        registration: registration
      }
    end

    def confirmation
      render locals: {
        registration: registration
      }
    end

    private

      def registration
        Registration.find(params[:id])
      end

      def get_form
        Form.find(params[:form_id])
      end

      def form_params(form)
        params.require(:form).permit(form.template.permitted_params)
      end

      def redirect_to_first_incomplete_form
        redirect_to checkout_form_registration_path registration, registration.forms.incomplete.first
      end

      def redirect_to_payment
        redirect_to checkout_payment_registration_path registration
      end

      def redirect_to_confirmation
        redirect_to checkout_confirmation_registration_path registration
      end

  end
end
