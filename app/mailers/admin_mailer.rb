class AdminMailer < ApplicationMailer
  def new_user_notification(user:)
    @user = user
    mail(to: "nazarysupport@gmail.com", subject: "New User Joined Nazary: #{user.name}")
  end
end
