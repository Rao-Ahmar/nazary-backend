class TripReminderJob < ApplicationJob
  queue_as :default

  def perform
    [7, 3, 1].each do |days_before|
      target_date = Date.current + days_before.days
      trips = Trip.active.where(start_date: target_date)

      trips.find_each do |trip|
        trip.bookings.confirmed.includes(:user).each do |booking|
          user = booking.user
          next unless user.notifications_enabled?

          # Deduplication: skip if already notified for this trip + days_before
          already_sent = user.notifications.where(
            notification_type: :trip_reminder
          ).where("data @> ?", { trip_id: trip.id.to_s, days_before: days_before.to_s }.to_json).exists?

          next if already_sent

          NotificationService.create(
            user: user,
            title: "Trip Reminder",
            body: "#{trip.title} starts in #{days_before} #{'day'.pluralize(days_before)}!",
            notification_type: :trip_reminder,
            data: { trip_id: trip.id.to_s, days_before: days_before.to_s }
          )
        end
      end
    end
  end
end
