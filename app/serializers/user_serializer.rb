class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :role, :admin, :avatar, :phone, :created_at,
             :profile_completed, :notifications_enabled,
             :referral_code, :referred_by,
             :points, :completed_trips_count,
             :corporate_trips_count, :corporate_level

  # Planner-only fields
  attributes :bio, :guild, :rating, :trips_hosted, :total_reviews,
             :agency_name, :agency_tagline, :years_experience, :agency_logo,
             :planner_rating,
             :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url,
             :cover_photo,
             :slug, :nazary_url, :instagram_verified, :tiktok_verified, :social_verified

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

  def referred_by
    return nil unless object.referred_by
    { id: object.referred_by.id.to_s, name: object.referred_by.name }
  end

  def created_at
    object.created_at.iso8601
  end

  def profile_completed
    object.profile_completed?
  end

  def rating
    return nil unless object.planner?
    object.cached_host_rating
  end

  def planner_rating
    return nil unless object.planner?
    object.cached_host_rating
  end

  def trips_hosted
    return nil unless object.planner?
    object.trips_count
  end

  def total_reviews
    return nil unless object.planner?
    Trip.where(user_id: object.id).sum(:reviews_count)
  end

  def nazary_url
    return nil unless object.planner?
    object.nazary_url
  end

  def social_verified
    return nil unless object.planner?
    object.social_verified?
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
      hash.delete(:slug)
      hash.delete(:nazary_url)
      hash.delete(:instagram_verified)
      hash.delete(:tiktok_verified)
      hash.delete(:social_verified)
    end
    hash
  end
end
