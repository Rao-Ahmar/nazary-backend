class NotificationService
  def self.create(user:, title:, body:, notification_type: :general, data: {})
    notification = user.notifications.create!(
      title: title,
      body: body,
      notification_type: notification_type,
      data: data
    )

    # Send push notification via Expo if user has a device token and notifications enabled
    if user.device_token.present? && user.notifications_enabled?
      ExpoPushService.send_push(
        device_token: user.device_token,
        title: title,
        body: body,
        data: data.merge(notification_id: notification.id.to_s)
      )
    end

    notification
  end
end
