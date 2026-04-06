class AuthService
  def self.find_or_create_user(login_credential)
    # Detect if it's an email or a phone number
    if login_credential.include?('@')
      User.find_or_create_by!(email: login_credential.downcase)
    else
      # Clean phone number (remove spaces/dashes)
      clean_phone = login_credential.gsub(/\D/, '')
      User.find_or_create_by!(phone: clean_phone)
    end
  end

  def self.generate_otp(user)
    code = rand(100000..999999).to_s
    user.update(otp_code: code, otp_sent_at: Time.current)
    
    # SIMULATION: In production, call Twilio or SendGrid here
    Rails.logger.info "--- [OTP SIMULATION] ---"
    Rails.logger.info "To: #{user.email || user.phone} | Code: #{code}"
    Rails.logger.info "------------------------"
    
    code
  end
end
