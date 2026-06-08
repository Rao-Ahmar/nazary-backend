class AdminBookingSerializer < ActiveModel::Serializer
  attributes :id, :trip_id, :traveler_id, :traveler_name, :traveler_email, :traveler_phone, :traveler_avatar,
             :trip_title, :trip_location, :trip_hero_image, :trip_start_date, :trip_price,
             :planner_id, :planner_name, :agency_name, :planner_phone,
             :status, :amount, :seats, :admin_approved, :total_trip_cost, :admin_commission,
             :admin_note, :payment_proofs, :created_at

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

  def traveler_email
    object.user.email
  end

  def traveler_phone
    object.user.phone
  end

  def traveler_avatar
    object.user.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.user.avatar) : nil
  rescue StandardError
    nil
  end

  def trip_title
    object.trip.title
  end

  def trip_location
    object.trip.location
  end

  def trip_hero_image
    object.trip.hero_image.attached? ? Rails.application.routes.url_helpers.url_for(object.trip.hero_image) : nil
  rescue StandardError
    nil
  end

  def trip_start_date
    object.trip.start_date&.iso8601
  end

  def trip_price
    object.trip.price
  end

  def planner_id
    object.trip.host.id.to_s
  end

  def planner_name
    object.trip.host.name
  end

  def agency_name
    object.trip.host.agency_name
  end

  def planner_phone
    object.trip.host.phone
  end

  def payment_proofs
    object.payment_proofs.order(created_at: :desc).map do |proof|
      PaymentProofSerializer.new(proof).as_json
    end
  end

  def seats
    object.seats
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

  def created_at
    object.created_at.iso8601
  end
end
