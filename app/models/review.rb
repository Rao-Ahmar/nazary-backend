class Review < ApplicationRecord
  belongs_to :trip, counter_cache: true
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :text, presence: true
  validates :user_id, uniqueness: { scope: :trip_id }

  after_commit :update_cached_ratings, on: [:create, :destroy]
  after_commit :update_cached_ratings_on_change, on: :update

  private

  def update_cached_ratings
    recalculate_trip_rating
    recalculate_host_rating
  end

  def update_cached_ratings_on_change
    return unless saved_change_to_rating?

    recalculate_trip_rating
    recalculate_host_rating
  end

  def recalculate_trip_rating
    return unless trip

    new_rating = trip.reviews.average(:rating)&.round(1) || 0.0
    trip.update_column(:cached_average_rating, new_rating)
  end

  def recalculate_host_rating
    host = trip&.host
    return unless host

    new_rating = Trip.where(user_id: host.id)
                     .where("reviews_count > 0")
                     .average(:cached_average_rating)
                     &.round(1) || 0.0
    host.update_column(:cached_host_rating, new_rating)
  end
end
