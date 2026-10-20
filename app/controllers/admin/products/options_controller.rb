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
        option = product.options.find(params[:id])
        previous_title = option.title
        option.update!(option_params)
        product.variants.find_each do |variant|
          chosen = variant.options.dup
          next unless chosen.key?(previous_title)

          value = chosen.delete(previous_title)
          chosen[option.title] = value if option.values.include?(value)
          variant.update!(options: chosen)
        end
        redirect_to admin_product_path(product)
      end

      def destroy
        product = Product.friendly.find(params[:product_id])
        option = product.options.find(params[:id])
        product.variants.find_each do |variant|
          chosen = variant.options.except(option.title)
          variant.update!(options: chosen)
        end
        option.destroy!
        redirect_to admin_product_path(product)
      end

      private
        def option_params
          params.require(:product_option).permit(:title, :values)
        end
    end
  end
end
