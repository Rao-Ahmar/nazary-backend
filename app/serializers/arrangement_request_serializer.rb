class ArrangementRequestSerializer < ActiveModel::Serializer
  attributes :id, :preferred_destination, :travel_dates, :group_size,
             :budget_min, :budget_max, :special_notes, :status,
             :linked_trip_id, :agency_id, :agency_name, :created_at, :updated_at

  belongs_to :traveler, serializer: UserSerializer

  def id
    object.id.to_s
  end

  def agency_id
    object.agency_id&.to_s
  end

  def agency_name
    object.agency&.agency_name || object.agency&.name
  end

  def linked_trip_id
    object.linked_trip_id&.to_s
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end
end
