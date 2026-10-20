module Admin
  module Products
    class ThumbnailsController < BaseController
      def destroy
        product = Product.friendly.find(params[:product_id])
        product.thumbnail.purge
        redirect_to admin_product_path(product)
      end
    end
  end
end
