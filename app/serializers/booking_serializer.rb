class BookingSerializer < ActiveModel::Serializer
  attributes :id, :trip_id, :traveler_id, :traveler_name, :traveler_avatar,
             :status, :amount, :created_at

  attribute :trip_title, if: -> { instance_options[:planner_view] }

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
end
