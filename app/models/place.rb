class Place < ApplicationRecord
  has_one_attached :cover_image
  has_many :place_reviews, dependent: :destroy

  validates :name, presence: true
  validates :region, presence: true

  def average_rating
    place_reviews.average(:rating)&.round(1) || 0.0
  end

  def review_count
    place_reviews.count
  end
end
