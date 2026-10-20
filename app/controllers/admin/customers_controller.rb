module Admin
  class CustomersController < BaseController
    def index
      @customers = User.order(:email_address)
    end

    def show
      @customer = User.find(params[:id])
    end

    def update
      @customer = User.find(params[:id])
      if demoting_last_admin?
        redirect_to admin_customer_path(@customer), alert: "The last admin cannot be demoted"
      else
        @customer.update!(admin: params.require(:user).fetch(:admin))
        redirect_to admin_customer_path(@customer)
      end
    end

    private
      def demoting_last_admin?
        @customer.admin? && ActiveModel::Type::Boolean.new.cast(params.dig(:user, :admin)) == false && User.where(admin: true).count == 1
      end
  end
end
