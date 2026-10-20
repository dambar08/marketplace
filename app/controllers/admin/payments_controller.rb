module Admin
  class PaymentsController < BaseController
    def index
      @payments = PaymentCollection.order(created_at: :desc)
    end

    def show
      @payment = PaymentCollection.find(params[:id])
    end
  end
end
