class NotifyNewTripJob < ApplicationJob
  queue_as :default

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip&.active?

    trip_month = trip.start_date.month
    notified_user_ids = []

    # Find travelers with matching preferences
    TripPreference.includes(:user).find_each do |pref|
      user = pref.user
      next unless user.traveler? && user.notifications_enabled?

      matches = false

      # Check budget match
      if pref.budget_min.present? && pref.budget_max.present?
        matches = trip.price >= pref.budget_min && trip.price <= pref.budget_max
      end

      # Check month match
      if pref.preferred_months.present? && pref.preferred_months.include?(trip_month)
        matches = true
      end

      # Check followed agency match
      if pref.followed_agency_id.present? && pref.followed_agency_id == trip.user_id
        matches = true
      end

      if matches
        NotificationService.create(
          user: user,
          title: "Matches your preferences!",
          body: "#{trip.title} in #{trip.location} matches what you're looking for",
          notification_type: :preference_match,
          data: { trip_id: trip.id.to_s }
        )
        notified_user_ids << user.id
      end
    end

    # Notify remaining travelers with notifications enabled
    User.where(role: :traveler, notifications_enabled: true)
        .where.not(id: notified_user_ids)
        .find_each do |user|
      NotificationService.create(
        user: user,
        title: "New Trip Available!",
        body: "#{trip.title} in #{trip.location} is now open for booking",
        notification_type: :new_trip,
        data: { trip_id: trip.id.to_s }
      )
    end
  end
end
