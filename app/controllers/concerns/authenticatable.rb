module Authenticatable
  extend ActiveSupport::Concern

  def current_user
    @current_user ||= authenticate_user_from_token
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  private

  def authenticate_user_from_token
    header = request.headers['Authorization']
    return nil if header.blank?

    token = header.split(' ').last # Expects "Bearer <token>"
    decoded = JwtService.decode(token)
    
    return nil unless decoded
    Lead.find_by(id: decoded[:user_id])
  end
end
