class OrdersController < ApplicationController
  def index
  end

  def show
    @order = Order.find_by_uuid(params[:id])
  end

  def current
    @order = Order.find_or_initialize_by(uuid: current_visit&.visit_token) do |order|
      order.user = current_user
    end
  end

  def checkout
    @order = Order.find_by_uuid(params[:id])

    authorize @order

    return redirect_to order_path(@order.uuid) unless @order.payment_required?

    @stripe_public_api_key = stripe_public_api_key
    @stripe_account = Tenant.current.stripe_account_id   

    # if session already captured then let's take a look
    if(@order.session_id.present?)
      session = Stripe::Checkout::Session.retrieve(@order.session_id, {
        stripe_account: @order.tenant.stripe_account_id,
        api_key: stripe_private_api_key
      })

      case session.status
      when 'open'
        # guard against creating new session
        return
      when 'complete'
        # guard against new session and redirect to orders#show
        return redirect_to(order_path(@order.uuid))
      when 'expired'
        # allow code to flow through and create new session
      end
    end

    #  get existing customer for email address
    customers = Stripe::Customer.list({ email: @order.email, limit: 1 }, {
      stripe_account: Tenant.current.stripe_account_id,
      api_key: stripe_private_api_key
    })
    customer = customers['data'][0]

    session_params = {
      customer: (customer['id'] if customer),
      customer_email: (@order.email unless customer),
      payment_method_types: ['card'],
      client_reference_id: "order-#{@order.uuid}",
      line_items: @order.registrations.collect do |registration|
        {
          name: registration.title,
          description: registration.description,
          images: [],
          amount: registration.price_in_cents,
          currency: 'usd',
          quantity: 1
        }
      end,
      payment_intent_data: {
        application_fee_amount: @order.application_fee_in_cents,
        description: @order.description
      },        
      success_url: confirm_order_url(@order.uuid),
      cancel_url: order_url(@order.uuid)        
    }
    session_options = {
      stripe_account: Tenant.current.stripe_account_id,
      api_key: stripe_private_api_key
    }   
    
    session = Stripe::Checkout::Session.create session_params, session_options 
    @order.update_attribute(:session_id, session.id)  
  end

  def confirm

    order = Order.find_by_uuid(params[:id])

    if order.completed?
      return redirect_to orders_path(order.uuid), flash: { info: 'Order has already been marked as completed' }
    end
    if order.session_id.blank?
      return redirect_to orders_path(order.uuid), flash: { error: 'Order has yet to complete checkout' }
    end

    session = Stripe::Checkout::Session.retrieve(order.session_id, {
      stripe_account: order.tenant.stripe_account_id,
      api_key: stripe_private_api_key
    })
    
    payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent, {
      stripe_account: order.tenant.stripe_account_id,
      api_key: stripe_private_api_key
    })

    if session.status == 'complete'
      order.update(payment_intent_id: session.payment_intent)
      order.touch(:completed_at)
      # RegistrationMailer.confirmation_email(registration.id, registration_url(registration.uuid)).deliver_now
      return redirect_to order_path(order.uuid), flash: { success: 'Checkout has been completed' }
    end

    redirect_to order_path(order.uuid), flash:  { error: "Checkout has not been completed (status: #{session.status})" }
  end 

  private

    def stripe_private_api_key
      Tenant.current.stripe_private_key.presence || ENV['STRIPE_SECRET_KEY']
    end
    
    def stripe_public_api_key
      Tenant.current.stripe_public_key.presence || ENV['STRIPE_PUBLIC_KEY']
    end    

end
