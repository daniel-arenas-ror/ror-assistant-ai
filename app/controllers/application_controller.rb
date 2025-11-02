class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :validate_user?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # before_action -> { sleep 1 }

  private

  def validate_user?
    # TODO: we need three type of validation
    # when user call the API, this should be public, that is a lead user
    # user from a company that need some configuration
    # super user

    # controller_path maybe with this we can know what kind of validation we should run

    current_user.nil? & current_admin_user.nil?
  end

  def current_company
    @current_company ||= current_user.company if user_signed_in?
  end

  helper_method :current_company

end
