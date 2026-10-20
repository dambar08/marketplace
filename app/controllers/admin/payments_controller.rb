module Admin
  class PaymentsController < BaseController
    def index
      @payments = PaymentCollection.order(created_at: :desc)
      @payments = @payments.where("status ILIKE ?", "%#{params[:q]}%") if params[:q].present?
      @payments = @payments.where(status: params[:status]) if params[:status].present?
      @payment_statuses = PaymentCollection.distinct.order(:status).pluck(:status)
    end

    def show
      @payment = PaymentCollection.find(params[:id])
    end
  end
end
