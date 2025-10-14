class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # before_action -> { sleep 1 }
end
