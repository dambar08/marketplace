module Admin
  class FulfillmentsController < BaseController
    def index
      @fulfillments = Fulfillment.awaiting.order(:id)
    end

    def show
      @fulfillment = Fulfillment.find(params[:id])
    end

    def update
      @fulfillment = Fulfillment.find(params[:id])
      @fulfillment.mark(params[:status], tracking_number: params[:tracking_number])
      redirect_to admin_fulfillment_path(@fulfillment)
    rescue ActiveRecord::RecordInvalid
      render :show, status: :unprocessable_content
    end
  end
end
