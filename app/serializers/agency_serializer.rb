class AgencySerializer < ActiveModel::Serializer
  attributes :id, :agency_name, :name, :bio, :agency_tagline, :city, :phone,
             :verified, :average_rating, :total_trips, :avatar, :agency_logo,
             :years_experience, :created_at,
             :youtube_url, :instagram_url, :tiktok_url, :twitter_url, :website_url,
             :cover_photo

  def id
    object.id.to_s
  end

  def average_rating
    object.average_planner_rating
  end

  def total_trips
    object.trips.count
  end

  def avatar
    object.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.avatar) : nil
  rescue StandardError
    nil
  end

  def agency_logo
    object.agency_logo.attached? ? Rails.application.routes.url_helpers.url_for(object.agency_logo) : nil
  rescue StandardError
    nil
  end

  def cover_photo
    object.cover_photo.attached? ? Rails.application.routes.url_helpers.url_for(object.cover_photo) : nil
  rescue StandardError
    nil
  end

  def phone
    # Only show phone if the requesting context allows it
    # By default, hide phone in public listing
    instance_options[:show_phone] ? object.phone : nil
  end

  def created_at
    object.created_at.iso8601
  end
end
