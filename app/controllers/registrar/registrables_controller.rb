class Registrar::RegistrablesController < ApplicationController
  before_filter :verify_admin, :except => [:index, :show]
  before_filter :mark_return_point, :only => [:new, :edit]
  before_action :set_registrable, only: [:show, :edit, :update, :destroy]

  # GET /registrar/registrables
  def index
    @registrables = Registrar::Registrable.all
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
      redirect_to @registrable, notice: 'Registrable was successfully created.'
    else
      flash[:error] = "Registrable could not be created" + @registrable.errors.count.to_s
      render :new
    end
  end

  # PATCH/PUT /registrar/registrables/1
  def update
    puts registrable_params.to_json
    if @registrable.update(registrable_params)
      redirect_to @registrable, notice: 'Registrable was successfully updated.'
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
      params.required(:registrar_registrable).permit(:title, :description, :quantity_allowed,
        registration_types_attributes: [ :id, :title, :description, :quantity_allowed, :price, :_destroy ])
    end
end
