class TripListSerializer < ActiveModel::Serializer
  attributes :id, :title, :location, :hero_image, :price, :currency,
             :duration, :dates, :start_date, :seats_left, :total_seats, :status, :tags, :rating, :review_count,
             :trip_type, :is_premium, :content_updated_at, :is_updated

  has_one :host, serializer: TripHostSerializer

  def id
    object.id.to_s
  end

  def hero_image
    if object.hero_image.attached?
      Rails.application.routes.url_helpers.url_for(object.hero_image)
    end
  rescue StandardError
    nil
  end

  def dates
    "#{object.start_date.strftime('%b %-d')} - #{object.end_date.strftime('%-d')}"
  end

  def seats_left
    object.seats_left
  end

  def rating
    object.average_rating
  end

  def review_count
    object.reviews.count
  end

  def content_updated_at
    object.content_updated_at&.iso8601
  end

  def is_updated
    object.content_updated_at.present? && object.content_updated_at > object.created_at
  end
end
