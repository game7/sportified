class Admin::ProductsController < Admin::AdminController
  skip_before_action :verify_admin, only: %i[index show]
  before_action :verify_admin_or_operations, only: %i[index show]
  before_action :mark_return_point, only: %i[new edit]
  before_action :set_product, only: %i[show edit update destroy]
  before_action :get_form_packets, only: %i[edit update new create]

  def index
    @products = Product.includes(:registrable).order(active: :desc, id: :desc)

    @pending_counts = Registration.joins(:product).group('products.id').pending.count
    @completed_counts = Registration.joins(:product).group('products.id').completed.count
    @abandoned_counts = Registration.joins(:product).group('products.id').abandoned.count
    @cancelled_counts = Registration.joins(:product).group('products.id').pending.count
    @completed_total = Registration.joins(:product).group('products.id').completed.sum(:price)

    @products = @products.active unless current_user_is_admin?
  end

  def show
    @registration_count = @product.registrations.count
    @registration_revenue = @product.registrations.sum(:price)
  end

  def new
    @product = params[:clone] ? Product.find(params[:clone]).dup : Product.new

    @product.assign_attributes(registrable_type: params[:registrable_type], registrable_id: params[:registrable_id])
    return unless @product.registrable_type == 'Event' && @product.registrable.present?

    @product.title = @product.registrable.summary
  end

  def edit; end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to [:admin, @product], notice: 'Product was successfully created.'
    else
      flash[:error] = 'Product could not be created'
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to [:admin, @product], notice: 'Product was successfully updated.'
    else
      flash[:error] = 'Product could not be created'
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  protected

  def set_breadcrumbs
    super
    add_breadcrumb 'Registration', admin_products_dashboard_path
    add_breadcrumb 'Products', admin_products_path
  end

  private

  def set_product
    @product = Product.includes(:variants).find(params[:id])
  end

  def product_params
    params.required(:product).permit(:title, :summary, :description, :quantity_allowed, :active, :private, :roster, :registrable_id, :registrable_type, :image,
                                     variants_attributes: %i[id title description form_packet_id display_order quantity_allowed hide_quantity_available price _destroy])
  end

  def get_form_packets
    @form_packets = FormPacket.all
  end
end
