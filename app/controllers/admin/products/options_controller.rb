module Admin
  module Products
    class OptionsController < BaseController
      def create
        product = Product.friendly.find(params[:product_id])
        product.options.create!(option_params)
        redirect_to admin_product_path(product)
      end

      def update
        product = Product.friendly.find(params[:product_id])
        product.options.find(params[:id]).update!(option_params)
        redirect_to admin_product_path(product)
      end

      def destroy
        product = Product.friendly.find(params[:product_id])
        product.options.find(params[:id]).destroy!
        redirect_to admin_product_path(product)
      end

      private
        def option_params
          params.require(:product_option).permit(:title, :values)
        end
    end
  end
end
