class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :trip_id, :user_id, :name, :avatar, :rating, :text, :date

  def id
    object.id.to_s
  end

  def trip_id
    object.trip_id.to_s
  end

  def user_id
    object.user_id.to_s
  end

  def name
    object.user.name
  end

  def avatar
    object.user.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.user.avatar) : nil
  rescue StandardError
    nil
  end

  def date
    object.created_at.strftime("%b %Y")
  end
end
