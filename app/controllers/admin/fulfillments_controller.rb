module Admin
  class FulfillmentsController < BaseController
    def index
      scope = params[:q].present? ? Fulfillment.order(:id) : Fulfillment.awaiting.order(:id)
      @fulfillments = if params[:q].present?
        needle = params[:q].downcase
        scope.select { |fulfillment| fulfillment.status_label.downcase.include?(needle) }
      else
        scope
      end
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
