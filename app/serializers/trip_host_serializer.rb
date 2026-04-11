class TripHostSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :guild, :rating, :phone, :trips_hosted

  def id
    object.id.to_s
  end

  def avatar
    object.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.avatar) : nil
  rescue StandardError
    nil
  end

  def rating
    object.trips.joins(:reviews).average("reviews.rating")&.round(1) || 0.0
  end

  def phone
    object.phone
  end

  def trips_hosted
    object.trips.count
  end
end
