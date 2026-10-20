module Admin
  class OrdersController < BaseController
    def index
      @orders = Order.order(created_at: :desc)
      @orders = @orders.where("id::text LIKE ?", "%#{params[:q]}%") if params[:q].present?
    end

    def show
      @order = Order.find(params[:id])
    end
  end
end
