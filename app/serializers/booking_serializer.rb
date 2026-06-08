class BookingSerializer < ActiveModel::Serializer
  attributes :id, :trip_id, :traveler_id, :traveler_name, :traveler_avatar,
             :status, :amount, :seats, :admin_note, :admin_approved,
             :total_trip_cost, :admin_commission, :created_at,
             :trip_title, :trip_hero_image, :trip_location, :trip_price,
             :traveler_phone, :traveler_email

  def id
    object.id.to_s
  end

  def trip_id
    object.trip_id.to_s
  end

  def traveler_id
    object.user_id.to_s
  end

  def traveler_name
    object.user.name
  end

  def traveler_avatar
    object.user.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.user.avatar) : nil
  rescue StandardError
    nil
  end

  def created_at
    object.created_at.iso8601
  end

  def trip_title
    object.trip.title
  end

  def trip_hero_image
    object.trip.hero_image.attached? ? Rails.application.routes.url_helpers.url_for(object.trip.hero_image) : nil
  rescue StandardError
    nil
  end

  def trip_location
    object.trip.location
  end

  def trip_price
    object.trip.price
  end

  # Reveal traveler contact info once admin has approved (persists across all statuses)
  def traveler_phone
    (object.admin_approved? || object.confirmed?) ? object.user.phone : nil
  end

  def traveler_email
    (object.admin_approved? || object.confirmed?) ? object.user.email : nil
  end

  def admin_approved
    object.admin_approved
  end

  def total_trip_cost
    object.trip.price * (object.seats || 1)
  end

  def admin_commission
    object.amount
  end
end
