class CorporateTripRequestSerializer < ActiveModel::Serializer
  attributes :id, :company_name, :estimated_people, :contact_email,
             :contact_phone, :special_notes, :status, :admin_note,
             :linked_trip_id, :created_at

  belongs_to :user, serializer: UserSerializer

  attribute :preferred_planner

  def id
    object.id.to_s
  end

  def linked_trip_id
    object.linked_trip_id&.to_s
  end

  def preferred_planner
    return nil unless object.preferred_planner
    { id: object.preferred_planner.id.to_s, name: object.preferred_planner.name }
  end

  def created_at
    object.created_at.iso8601
  end
end
