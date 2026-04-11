class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :avatar, :phone, :created_at,
             :profile_completed, :notifications_enabled

  # Planner-only fields
  attributes :bio, :guild, :rating, :trips_hosted, :total_reviews,
             :agency_name, :agency_tagline, :years_experience, :agency_logo,
             :planner_rating,
             :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url,
             :cover_photo

  def id
    object.id.to_s
  end

  def avatar
    object.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.avatar) : nil
  rescue StandardError
    nil
  end

  def cover_photo
    return nil unless object.planner?
    object.cover_photo.attached? ? Rails.application.routes.url_helpers.url_for(object.cover_photo) : nil
  rescue StandardError
    nil
  end

  def agency_logo
    return nil unless object.planner?
    object.agency_logo.attached? ? Rails.application.routes.url_helpers.url_for(object.agency_logo) : nil
  rescue StandardError
    nil
  end

  def created_at
    object.created_at.iso8601
  end

  def profile_completed
    object.profile_completed?
  end

  def rating
    return nil unless object.planner?
    object.trips.joins(:reviews).average("reviews.rating")&.round(1) || 0.0
  end

  def planner_rating
    return nil unless object.planner?
    object.average_planner_rating
  end

  def trips_hosted
    return nil unless object.planner?
    object.trips.count
  end

  def total_reviews
    return nil unless object.planner?
    Review.where(trip: object.trips).count
  end

  def attributes(*args)
    hash = super
    unless object.planner?
      hash.delete(:bio)
      hash.delete(:guild)
      hash.delete(:rating)
      hash.delete(:trips_hosted)
      hash.delete(:total_reviews)
      hash.delete(:agency_name)
      hash.delete(:agency_tagline)
      hash.delete(:years_experience)
      hash.delete(:agency_logo)
      hash.delete(:planner_rating)
      hash.delete(:youtube_url)
      hash.delete(:instagram_url)
      hash.delete(:tiktok_url)
      hash.delete(:twitter_url)
      hash.delete(:website_url)
      hash.delete(:cover_photo)
    end
    hash
  end
end
