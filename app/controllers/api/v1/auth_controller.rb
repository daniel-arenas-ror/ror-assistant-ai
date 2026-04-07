module Api
  module V1
    class AuthController < BaseController
      def request_otp
        user = AuthService.find_or_create_user(params[:login])
        AuthService.generate_otp(user)

        render json: { message: "Code sent successfully" }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def verify_otp
        user = Lead.find_by(email: params[:login].downcase) || Lead.find_by(phone: params[:login].gsub(/\D/, ''))

        if user && user.otp_code == params[:code] && user.otp_sent_at > 5.minutes.ago
          # Success: Clear the code and issue a token
          user.update(otp_code: nil)
          token = JwtService.encode(user_id: user.id)
          
          render json: { 
            token: token, 
            user: { id: user.id, email: user.email, phone: user.phone } 
          }, status: :ok
        else
          render json: { error: "Invalid or expired code" }, status: :unauthorized
        end
      end

      def google_login
        payload = Google::Auth::IDTokens.verify_oidc(
          params[:token],
          aud: ENV['GOOGLE_CLIENT_ID']
        )

        p " PAYLOAD: #{payload.inspect} "
        session_token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, ENV['JWT_SECRET'])

        user = User.find_or_create_by!(email: payload['email']) do |u|
          u.name = payload['name']
          # u.image = payload['picture']
          # Set a random password if using Devise/has_secure_password
          u.password = SecureRandom.hex(16) if u.respond_to?(:password=)
        end

        render json: { name: user.name, email: user.email, session_token: session_token }, status: :ok
      rescue Google::Auth::IDTokens::VerificationError => e
        p " #{e.message} "
        render json: { error: 'Invalid Google Token' }, status: :unauthorized
      end
    end
  end
end
