class TripRequestSerializer < ActiveModel::Serializer
  attributes :id, :traveler_id, :traveler_name, :traveler_avatar,
             :planner_id, :planner_name, :planner_avatar,
             :destination, :start_date, :end_date, :seats,
             :category, :budget, :note, :status, :created_at

  # Phone visibility: only when status is accepted
  attribute :traveler_phone, if: -> { object.accepted? }
  attribute :planner_phone, if: -> { object.accepted? }

  def id
    object.id.to_s
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

  def traveler_phone
    object.user.phone
  end

  def planner_id
    object.planner_id.to_s
  end

  def planner_name
    object.planner.name
  end

  def planner_avatar
    object.planner.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.planner.avatar) : nil
  rescue StandardError
    nil
  end

  def planner_phone
    object.planner.phone
  end

  def start_date
    object.start_date.iso8601
  end

  def end_date
    object.end_date.iso8601
  end

  def budget
    object.budget&.to_f
  end

  def created_at
    object.created_at.iso8601
  end
end
