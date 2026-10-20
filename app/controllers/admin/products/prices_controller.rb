module Admin
  module Products
    class PricesController < BaseController
      def create
        product = Product.friendly.find(params[:product_id])
        variant = product.variants.find(params[:variant_id])
        variant.prices.create!(price_params)
        redirect_to admin_product_path(product, anchor: "variant-#{variant.id}")
      end

      def update
        product = Product.friendly.find(params[:product_id])
        variant = product.variants.find(params[:variant_id])
        variant.prices.find(params[:id]).update!(price_params)
        redirect_to admin_product_path(product, anchor: "variant-#{variant.id}")
      end

      def destroy
        product = Product.friendly.find(params[:product_id])
        variant = product.variants.find(params[:variant_id])
        variant.prices.find(params[:id]).destroy!
        redirect_to admin_product_path(product, anchor: "variant-#{variant.id}")
      end

      private
        def price_params
          params.require(:product_variant_price).permit(:amount, :currency)
        end
    end
  end
end
