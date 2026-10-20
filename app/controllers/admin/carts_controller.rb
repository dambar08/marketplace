module Admin
  class CartsController < BaseController
    def index
      @carts = Cart.order(created_at: :desc)
    end

    def show
      @cart = Cart.find(params[:id])
      @promotions = Promotion.order(:code)
    end

    def update
      @cart = Cart.find(params[:id])
      promotion = params[:promotion_id].present? ? Promotion.find(params[:promotion_id]) : nil
      @cart.apply_promotion(promotion)
      redirect_to admin_cart_path(@cart)
    end
  end
end
