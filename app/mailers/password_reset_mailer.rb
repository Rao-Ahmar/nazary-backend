class PasswordResetMailer < ApplicationMailer
  def reset_link(user:, token:)
    @user = user
    @reset_url = "https://nazary.pk/reset-password?token=#{token}"
    mail(to: user.email, subject: "Reset Your Nazary Password")
  end
end
