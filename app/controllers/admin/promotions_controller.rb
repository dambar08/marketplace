module Admin
  class PromotionsController < BaseController
    def index
      @promotions = Promotion.order(:code)
    end

    def new
      @promotion = Promotion.new
    end

    def create
      @promotion = Promotion.new(promotion_params)
      if @promotion.save
        redirect_to admin_promotion_path(@promotion)
      else
        render :new, status: :unprocessable_content
      end
    end

    def show
      @promotion = Promotion.find(params[:id])
    end

    def edit
      @promotion = Promotion.find(params[:id])
    end

    def update
      @promotion = Promotion.find(params[:id])
      if @promotion.update(promotion_params)
        redirect_to admin_promotion_path(@promotion)
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      Promotion.find(params[:id]).destroy!
      redirect_to admin_promotions_path
    end

    private
      def promotion_params
        params.require(:promotion).permit(:code, :value)
      end
  end
end
