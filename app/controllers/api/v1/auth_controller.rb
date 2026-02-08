module Api
  module V1
    class AuthController < BaseController
      def google_login
        payload = Google::Auth::IDTokens.verify_oidc(
          params[:token], 
          aud: ENV['GOOGLE_CLIENT_ID']
        )

        session_token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ENV['JWT_SECRET'])

        user = User.find_or_create_by!(email: payload['email']) do |u|
          u.name = payload['name']
          # u.image = payload['picture']
          # Set a random password if using Devise/has_secure_password
          u.password = SecureRandom.hex(16) if u.respond_to?(:password=)
        end

        render json: { name: user.name, email: user.email, session_token: session_token }, status: :ok
      rescue Google::Auth::IDTokens::VerificationError => e
        render json: { error: 'Invalid Google Token' }, status: :unauthorized
      end
    end
  end
end
