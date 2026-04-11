class TripPreferenceSerializer < ActiveModel::Serializer
  attributes :id, :budget_min, :budget_max, :preferred_months,
             :followed_agency_id, :followed_agency_name

  def id
    object.id.to_s
  end

  def followed_agency_name
    object.followed_agency&.agency_name || object.followed_agency&.name
  end
end
