class TripHostSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :guild, :rating, :trips_hosted,
             :instagram_url, :tiktok_url, :nazary_url, :instagram_verified, :tiktok_verified

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

  def trips_hosted
    object.trips.count
  end

  def nazary_url
    object.nazary_url
  end
end
