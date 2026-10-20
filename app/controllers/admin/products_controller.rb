module Admin
  class ProductsController < BaseController
    def index
      @products = Product.order(:title)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_product_path(@product)
      else
        render :new, status: :unprocessable_content
      end
    end

    def show
      @product = Product.friendly.find(params[:id])
    end

    def edit
      @product = Product.friendly.find(params[:id])
    end

    def update
      @product = Product.friendly.find(params[:id])
      if @product.update(product_params)
        redirect_to admin_product_path(@product)
      else
        render :edit, status: :unprocessable_content
      end
    end

    private
      def product_params
        params.require(:product).permit(:title, :subtitle, :description, :thumbnail)
      end
  end
end
