module Api
  module V1
    class AssistantsController < BaseController
      def show
        render json:  Assistant.find_by_slug(params[:id])
      end
    end
  end
end
