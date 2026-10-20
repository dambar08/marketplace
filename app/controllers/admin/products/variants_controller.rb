module Admin
  module Products
    class VariantsController < BaseController
      def create
        product = Product.friendly.find(params[:product_id])
        product.variants.create!(variant_attributes(product))
        redirect_to admin_product_path(product)
      end

      def update
        product = Product.friendly.find(params[:product_id])
        product.variants.find(params[:id]).update!(variant_attributes(product))
        redirect_to admin_product_path(product)
      end

      def destroy
        product = Product.friendly.find(params[:product_id])
        product.variants.find(params[:id]).destroy!
        redirect_to admin_product_path(product)
      end

      private
        def variant_attributes(product)
          raw = params.require(:product_variant).permit(:title, :sku, :inventory_quantity, :allow_backorder, chosen_values: {})
          chosen = raw.delete(:chosen_values).to_h
          allowed = product.options.each_with_object({}) do |option, selections|
            value = chosen[option.title].to_s
            selections[option.title] = value if option.values.include?(value)
          end
          raw.merge(options: allowed)
        end
    end
  end
end
