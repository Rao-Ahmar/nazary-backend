class RewardUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :points, :completed_trips_count,
             :surprise_gift_eligible, :surprise_gift_sent,
             :free_trip_eligible, :free_trip_arranged,
             :free_trip_pair

  def id
    object.id.to_s
  end

  def free_trip_pair
    return nil unless object.free_trip_pair
    { id: object.free_trip_pair.id.to_s, name: object.free_trip_pair.name }
  end
end
