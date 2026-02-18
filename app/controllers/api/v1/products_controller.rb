module Api
  module V1
    class ProductsController < BaseController
      def show
        render json: Product.find(params[:id])
      end
    end
  end
end
