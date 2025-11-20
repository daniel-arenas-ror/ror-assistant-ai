module Api
  module V1
    class AssistantsController < BaseController
      def show
        p " params #{params}"

        render json: { message: "Assistant details" }
      end
    end
  end
end