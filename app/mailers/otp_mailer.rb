class OtpMailer < ApplicationMailer
  def send_code(email:, code:, phone_number:)
    @code = code
    @phone_number = phone_number
    mail(to: email, subject: "Your Nazary Verification Code: #{code}")
  end
end
