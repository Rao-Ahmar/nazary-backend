class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :region, :description, :latitude, :longitude,
             :cover_image, :rating, :review_count

  def id
    object.id.to_s
  end

  def cover_image
    object.cover_image.attached? ? Rails.application.routes.url_helpers.url_for(object.cover_image) : nil
  rescue StandardError
    nil
  end

  def latitude
    object.latitude&.to_f
  end

  def longitude
    object.longitude&.to_f
  end

  def rating
    object.average_rating
  end

  def review_count
    object.review_count
  end
end
