class PlaceReview < ApplicationRecord
  belongs_to :place
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :text, presence: true
  validates :user_id, uniqueness: { scope: :place_id, message: "has already reviewed this place" }
end
