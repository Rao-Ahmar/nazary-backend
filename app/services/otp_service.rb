class OtpService
  def self.generate(phone_number)
    otp = OtpVerification.generate_for(phone_number)
    Rails.logger.info "========================================="
    Rails.logger.info "OTP for #{phone_number}: #{otp.code}"
    Rails.logger.info "========================================="
    otp
  end

  def self.verify(phone_number, code)
    otp = OtpVerification.active.where(phone_number: phone_number).order(created_at: :desc).first
    return false unless otp
    otp.verify!(code)
  end
end
