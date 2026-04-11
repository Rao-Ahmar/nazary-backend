class CoupleRequestSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :partner_name, :destination_preference,
             :travel_dates, :budget_range, :special_requests,
             :status, :linked_trip_id, :created_at

  def id
    object.id.to_s
  end

  def user_id
    object.user_id.to_s
  end

  def linked_trip_id
    object.linked_trip_id&.to_s
  end

  def created_at
    object.created_at.iso8601
  end
end
