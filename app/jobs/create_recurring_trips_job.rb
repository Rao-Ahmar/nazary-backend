class CreateRecurringTripsJob < ApplicationJob
  queue_as :default

  # Run daily. For each active recurring trip, check if the next occurrence
  # is within 2 days. If so, clone the trip with new dates and auto-publish it.
  def perform
    Trip.active.recurring.find_each do |template|
      rule = template.recurring_rule
      next unless rule.is_a?(Hash) && rule["day_of_week"].present?

      target_dow = rule["day_of_week"]  # 0=Sunday .. 6=Saturday
      next_date  = next_occurrence(target_dow)

      # Only create if the next occurrence is within 2 days
      next unless next_date <= Date.current + 2.days

      # Skip if we already created an instance for this date
      already_exists = Trip.where(source_trip_id: template.id)
                           .where(start_date: next_date)
                           .exists?
      next if already_exists

      duration_days = template.duration_in_days
      new_end_date  = next_date + duration_days.days

      new_trip = template.host.trips.new(
        title: template.title,
        subtitle: template.subtitle,
        description: template.description,
        location: template.location,
        price: template.price,
        currency: template.currency,
        duration: template.duration,
        start_date: next_date,
        end_date: new_end_date,
        total_seats: template.total_seats,
        trip_type: template.trip_type,
        tags: template.tags,
        highlights: template.highlights,
        source_trip_id: template.id
      )

      next unless new_trip.save

      # Clone itinerary
      template.itinerary_days.each do |day|
        new_trip.itinerary_days.create!(day: day.day, title: day.title, desc: day.desc)
      end

      # Clone hero image
      if template.hero_image.attached?
        new_trip.hero_image.attach(template.hero_image.blob)
      end

      # Clone gallery
      template.gallery.each { |img| new_trip.gallery.attach(img.blob) }

      # Auto-publish
      new_trip.active!
      NotifyNewTripJob.perform_later(new_trip.id)

      Rails.logger.info "[RecurringTrips] Created trip ##{new_trip.id} from template ##{template.id} for #{next_date}"
    end
  end

  private

  def next_occurrence(target_dow)
    date = Date.current + 1.day
    date += 1.day until date.wday == target_dow
    date
  end
end
