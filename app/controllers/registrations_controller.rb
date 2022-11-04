# == Schema Information
#
# Table name: registrations
#
#  id                :integer          not null, primary key
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#  first_name        :string(40)
#  last_name         :string(40)
#  email             :string
#  payment_id        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  price             :decimal(20, 4)
#  form_packet_id    :integer
#  confirmation_code :string
#  birthdate         :date
#  session_id        :text
#  payment_intent_id :text
#  uuid              :string
#  completed_at      :datetime
#  abandoned_at      :datetime
#  cancelled_at      :datetime
#  checked_in_at     :datetime
#
# Indexes
#
#  index_registrations_on_tenant_id  (tenant_id)
#  index_registrations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#

class RegistrationsController < ApplicationController
  before_action :verify_user, only: [:index]
  before_action :redirect_https

  def show
    render locals: { registration: Registration.find_by_uuid!(params[:id]) }
  end  

  def index
    @registrations = current_user.registrations.includes(:product, :variant).order("created_at DESC")
  end

  def new
    warn_duplicate = current_user&.registrations&.where(variant: variant)&.any?
    latest = current_user&.registrations&.last
    registration_attrs = {
      email: current_user&.email,
      first_name: latest&.first_name || current_user&.first_name,
      last_name: latest&.last_name || current_user&.last_name,
      birthdate: latest&.birthdate
    }
    registration = variant.registrations.build(registration_attrs)
    variant.form_packet.templates.each do |template|
      registration.forms.build({ template: template, registration: registration })
    end if variant.form_packet
    render locals: {
      warn_duplicate: warn_duplicate,
      variant: variant,
      registration: registration,
      vouchers: current_user&.vouchers&.available || []
    }
  end

  def create

    registration = variant.registrations.build(registration_params.except(:forms_attributes))

    registration.order = Order.find_or_create_by!(uuid: current_visit&.visit_token) do |order|
      order.first_name = registration.first_name
      order.last_name = registration.last_name
      order.email = registration.email
      order.user = current_user
    end
    
    # we have to build and initialize forms before assigning attributes so that the
    # dynamic setters and accessors can be created
    variant.form_packet.templates.each_with_index do |template, i|
      form = registration.forms.build({ template: template, registration: registration }).add_element_accessors
      form.completed = true
      form.assign_attributes(form_params[i.to_s].permit(template.permitted_params))
    end if variant.form_packet
    
    registration.user = current_user if current_user
    
    if registration.save
      # unless registration.payment_required?
      #   RegistrationMailer.confirmation_email(registration.id, registration_url(registration.uuid)).deliver_now
      # end
      # redirect_to collect_registration_path(registration.uuid) 
      redirect_to cart_path
    else
      flash[:error] = "Registration could not be completed"
      registration.errors[:base].each do |message|
        flash[:error] = message
      end
      render :new, locals: {
        warn_duplicate: current_user&.registrations&.where(variant: variant)&.any?,
        potential_duplicates: Registration.where({
          variant: variant,
          last_name: registration.last_name,
          birthdate: registration.birthdate
        }),
        registration: registration,
        variant: variant,
        vouchers: current_user&.vouchers&.available || []
      }
    end
  end
  

  def collect
    @registration = Registration.find_by_uuid(params[:id])
    @stripe_public_api_key = stripe_public_api_key
    @stripe_account = Tenant.current.stripe_account_id    

    unless @registration.payment_required?
      return redirect_to registration_path(@registration.uuid)
    end

    # if session already captured then let's take a look
    if(@registration.session_id.present?)
      session = Stripe::Checkout::Session.retrieve(@registration.session_id, {
        stripe_account: @registration.tenant.stripe_account_id,
        api_key: api_key
      })

      case session.status
      when 'open'
        # guard against creating new session
        return
      when 'complete'
        # guard against new session and redirect to registration#show
        return redirect_to(registration_path(@registration.uuid))
      when 'expired'
        # allow code to flow through and create new session
      end
    end

    #  get existing customer for email address
    customers = Stripe::Customer.list({ email: @registration.email, limit: 1 }, {
      stripe_account: Tenant.current.stripe_account_id,
      api_key: api_key
    })
    customer = customers['data'][0]

    session_params = {
      customer: (customer['id'] if customer),
      customer_email: (@registration.email unless customer),
      payment_method_types: ['card'],
      client_reference_id: @registration.id,
      line_items: [
        {
          name: @registration.product.title,
          description: "#{@registration.product.title}: #{@registration.variant.title}",
          images: [],
          amount: @registration.price_in_cents,
          currency: 'usd',
          quantity: 1
        }
      ],
      payment_intent_data: {
        application_fee_amount: @registration.application_fee_in_cents,
        description: "#{@registration.product.title}: #{@registration.variant.title}"
      },        
      success_url: confirm_registration_url(@registration.uuid),
      cancel_url: registration_url(@registration.uuid)        
    }
    session_options = {
      stripe_account: Tenant.current.stripe_account_id,
      api_key: api_key
    }   
    
    session = Stripe::Checkout::Session.create session_params, session_options    
    
    @registration.update!(session_id: session.id, payment_intent_id: session.payment_intent)  

  end


  def confirm

    registration = Registration.find_by_uuid(params[:id])

    if registration.completed?
      return redirect_to registration_path(registration.uuid), flash: { info: 'Registration has already been marked as completed' }
    end
    if registration.session_id.blank?
      return redirect_to registration_path(registration.uuid), flash: { error: 'Registration has yet to complete checkout' }
    end

    session = Stripe::Checkout::Session.retrieve(registration.session_id, {
      stripe_account: registration.tenant.stripe_account_id,
      api_key: api_key
    })
    
    payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent, {
      stripe_account: registration.tenant.stripe_account_id,
      api_key: api_key
    })

    if session.status == 'complete'
      registration.update(payment_id: registration.payment_intent_id)
      registration.touch(:completed_at)
      RegistrationMailer.confirmation_email(registration.id, registration_url(registration.uuid)).deliver_now
      return redirect_to registration_path(registration.uuid), flash: { success: 'Checkout has been completed' }
    end

    redirect_to registration_path(registration.uuid), flash:  { error: "Registration Checkout has not been completed (status: #{session.status})" }
  end  


  private

    def api_key
      Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']
    end

    def variant
      Variant.find(params[:variant_id])
    end

    def registration_params
      params.require(:registration).permit(:first_name, :last_name, :birthdate, :email, :confirm, :voucher_id, voucher: [:id])
    end

    def form_params
      params.require(:registration).fetch(:forms_attributes, {})
    end
    
    def stripe_public_api_key
      Tenant.current.stripe_public_key.presence || ENV['STRIPE_PUBLIC_KEY']
    end  

end
