# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                 :integer          not null, primary key
#  tenant_id          :integer
#  registrable_id     :integer
#  title              :string(30)
#  description        :text
#  price              :decimal(20, 4)
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Registrar::RegistrationTypesController < ApplicationController
  before_action :set_registrar_registration_type, only: [:show, :edit, :update, :destroy]

  # GET /registrar/registration_types
  def index
    @registrar_registration_types = Registrar::RegistrationType.all
  end

  # GET /registrar/registration_types/1
  def show
  end

  # GET /registrar/registration_types/new
  def new
    @registrar_registration_type = Registrar::RegistrationType.new
  end

  # GET /registrar/registration_types/1/edit
  def edit
  end

  # POST /registrar/registration_types
  def create
    @registrar_registration_type = Registrar::RegistrationType.new(registrar_registration_type_params)

    if @registrar_registration_type.save
      redirect_to @registrar_registration_type, notice: 'Registration type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /registrar/registration_types/1
  def update
    if @registrar_registration_type.update(registrar_registration_type_params)
      redirect_to @registrar_registration_type, notice: 'Registration type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /registrar/registration_types/1
  def destroy
    @registrar_registration_type.destroy
    redirect_to registrar_registration_types_url, notice: 'Registration type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registrar_registration_type
      @registrar_registration_type = Registrar::RegistrationType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def registrar_registration_type_params
      params.require(:registrar_registration_type).permit(:session_id, :title, :description, :price, :quantity_allowed, :quantity_available)
    end
end
