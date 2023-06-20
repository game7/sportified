class Next::Admin::ProductsController < Next::Admin::BaseController
  def index
    inertia props: {
      products: Product.all,
      registrations: Registration.summarize,
      events: Event.with_product.as_registrable
    }
  end

  def show
    product = Product.find(params[:id])

    inertia props: {
      product: product,
      variants: product.variants,
      registrations: product.registrations
    }
  end
end
