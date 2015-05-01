class Users::ProductsController < Users::BaseController

  before_action :set_product, only: [:show, :description, :show_one_click]
  before_action :available_quantity, only: [:show, :description, :show_one_click]

  def index
    set_products(Variant.available)

    displayed_variant_ids = Variant.available.ids & Variant.where(product_id: @products.ids).ids
    @single_variants = Variant.where(id: displayed_variant_ids).single_order.includes(:price)
    @subscription_variants = Variant.where(id: displayed_variant_ids).subscription_order.includes(:price)
    # set_prices(displayed_variant_ids)
    top_image(@single_variants)
  end

  def show
    @preview_images = @product.preview_images('top') #to do 共通化
  end

  def show_one_click
    @preview_images = @product.preview_images('top')

    quantity = 1 #default value, would be updated on #update_max_used_point
    @max_used_point = CheckoutValidityChecker.new.unique_variant_max_used_point(current_user, Variant.find(@product.variants.single_order.first), quantity)

    @gmo_cards = GmoMultiPayment::Card.new(current_user).search
  end

  def description
    @description_images = @product.preview_images('description')
  end

  def update_max_used_point
    updated_max_used_point = CheckoutValidityChecker.new.unique_variant_max_used_point(current_user, Variant.find(params[:variant_id]), params[:quantity])
    render json: updated_max_used_point
  end

  private

    def set_product
      @product = Product.find(params[:id])
      reject_invalid_product
    end

    def set_products(available_variants)
      displayed_product_ids = Product.available.try(:ids) & current_user.shown_product_ids
      @products = Product.where(id: displayed_product_ids).page(params[:page])
    end

    def set_prices(variant_ids)
      single_variants = Variant.where(id: variant_ids).single_order
      @single_prices_indexed_by_variant_id = Price.where(variant_id: single_variants.ids).index_by(&:variant_id)

      subscription_variants = Variant.where(id: variant_ids).subscription_order
      @subscription_prices_indexed_by_variant_id = Price.where(variant_id: subscription_variants.ids).index_by(&:variant_id)
    end

    def top_image(variants)
      @images = Image.where(id: VariantImageWhereabout.top.where(variant_id: variants.ids).pluck(:image_id)).order('position ASC')
    end

    def available_quantity
      @available_quantity = Array(1..Product::AvailableQuantity)
    end

    def reject_invalid_product
      redirect_to products_path unless ( @product.available? && @product.displayed?(current_user) )
    end

end
