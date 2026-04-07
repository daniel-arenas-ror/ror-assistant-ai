class AuthService
  def self.find_or_create_user(login_credential, company_id)
    # Detect if it's an email or a phone number
    if login_credential.include?('@')
      lead = Lead.find_or_create_by!(email: login_credential.downcase)
    else
      # Clean phone number (remove spaces/dashes)
      clean_phone = login_credential.gsub(/\D/, '')
      lead = Lead.find_or_create_by!(phone: clean_phone)
    end

    lead.lead_companies.find_or_create_by!(company_id: company_id)
    lead
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
