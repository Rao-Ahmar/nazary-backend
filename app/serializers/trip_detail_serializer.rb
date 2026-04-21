class TripDetailSerializer < TripListSerializer
  attributes :subtitle, :description, :gallery, :total_seats, :status,
             :highlights, :itinerary, :reviews, :start_date, :end_date, :created_at, :recent_updates,
             :trip_type, :is_premium, :recurring_rule, :my_booking_status

  def gallery
    object.gallery.map do |img|
      Rails.application.routes.url_helpers.url_for(img)
    end
  rescue StandardError
    []
  end

  def itinerary
    object.itinerary_days.map { |d| { day: d.day.to_s, title: d.title, desc: d.desc } }
  end

  def reviews
    object.reviews.includes(:user).order(created_at: :desc).map do |r|
      ReviewSerializer.new(r).as_json
    end
  end

  def created_at
    object.created_at.iso8601
  end

  def recent_updates
    object.trip_updates.order(created_at: :desc).limit(5).map do |u|
      TripUpdateSerializer.new(u).as_json
    end
  end

  def my_booking_status
    return nil unless scope.present? && scope.traveler?
    object.bookings.find_by(user: scope)&.status
  end
end
