module Api
  module V1
    class BaseController < ActionController::API
      include Authenticatable
      before_action :set_locale

      private

      def set_locale
        # TODO: create locale params to company
        # I18n.locale = params[:locale] || I18n.default_locale
        I18n.locale = :es || I18n.default_locale
      end
    end
  end
end
