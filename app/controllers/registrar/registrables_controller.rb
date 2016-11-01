# == Schema Information
#
# Table name: registrar_registrables
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(30)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tenant_id          :integer
#

class Registrar::RegistrablesController < ApplicationController
  before_filter :verify_admin, :except => [:index, :show]
  before_filter :mark_return_point, :only => [:new, :edit]
  before_action :set_registrable, only: [:show, :edit, :update, :destroy]

  # GET /registrar/registrables
  def index
    puts ENV
    @registrables = Registrar::Registrable.all
    @stripe_url = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CLIENT_ID']}&scope=read_write"
  end

  # GET /registrar/registrables/1
  def show
  end

  # GET /registrar/registrables/new
  def new
    @registrable = Registrar::Registrable.new
  end

  # GET /registrar/registrables/1/edit
  def edit
  end

  # POST /registrar/registrables
  def create
    @registrable = Registrar::Registrable.new(registrable_params)

    if @registrable.save
      redirect_to [:registrar, @registrable], notice: 'Registrable was successfully created.'
    else
      flash[:error] = "Registrable could not be created"
      render :new
    end
  end

  # PATCH/PUT /registrar/registrables/1
  def update
    puts registrable_params.to_json
    if @registrable.update(registrable_params)
      redirect_to [:registrar, @registrable], notice: 'Registrable was successfully updated.'
    else
      flash[:error] = "Registrable could not be created"
      render :edit
    end
  end

  # DELETE /registrar/registrables/1
  def destroy
    @registrable.destroy
    redirect_to registrar_registrables_url, notice: 'Registrable was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_registrable
      @registrable = Registrar::Registrable.includes(:registration_types).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def registrable_params
      params.required(:registrable).permit(:title, :description, :quantity_allowed,
        registration_types_attributes: [ :id, :title, :description, :quantity_allowed, :price, :_destroy ])
    end
end
