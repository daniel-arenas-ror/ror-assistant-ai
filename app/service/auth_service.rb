class AuthService
  def self.find_or_create_user(login_credential)
    if login_credential.include?('@')
      email = login_credential.downcase.strip
      user = Lead.find_by(email: email)
    else
      phone = login_credential.gsub(/\D/, '') # Clean to digits only
      user = Lead.find_by(phone: phone)
    end

    return user if user

    Lead.create!(
      email: email, # Will be nil if they provided a phone
      phone: phone, # Will be nil if they provided an email
      password: SecureRandom.hex(16)
    )
  end

  def self.generate_otp(lead)
    code = rand(100000..999999).to_s
    lead.update(otp_code: code, otp_sent_at: Time.current)
    
    # SIMULATION: In production, call Twilio or SendGrid here
    Rails.logger.info "--- [OTP SIMULATION] ---"
    Rails.logger.info "To: #{lead.email || lead.phone} | Code: #{code}"
    Rails.logger.info "------------------------"
    
    code
  end
end
