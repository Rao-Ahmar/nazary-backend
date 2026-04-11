class Review < ApplicationRecord
  belongs_to :trip
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :text, presence: true
  validates :user_id, uniqueness: { scope: :trip_id }
end
