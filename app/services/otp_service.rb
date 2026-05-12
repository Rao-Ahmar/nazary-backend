class OtpService
  def self.generate(phone_number, email: nil)
    otp = OtpVerification.generate_for(phone_number)
    Rails.logger.info "========================================="
    Rails.logger.info "OTP for #{phone_number}: #{otp.code}"
    Rails.logger.info "========================================="

    # Send OTP via email if an email address is available
    if email.present?
      OtpMailer.send_code(email: email, code: otp.code, phone_number: phone_number).deliver_later
      Rails.logger.info "OTP email queued for #{email}"
    end

    otp
  end

  def self.verify(phone_number, code)
    otp = OtpVerification.active.where(phone_number: phone_number).order(created_at: :desc).first
    return false unless otp
    otp.verify!(code)
  end
end
