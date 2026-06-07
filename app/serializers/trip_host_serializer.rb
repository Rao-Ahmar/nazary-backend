class TripHostSerializer < ActiveModel::Serializer
  attributes :id, :name, :agency_name, :avatar, :guild, :rating, :trips_hosted,
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
    object.cached_host_rating
  end

  def trips_hosted
    object.trips_count
  end

  def nazary_url
    object.nazary_url
  end
end
