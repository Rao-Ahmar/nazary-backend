class BikeProfile < ApplicationRecord
  belongs_to :user

  enum :experience_level, { beginner: 0, intermediate: 1, advanced: 2 }

  validates :bike_model, presence: true
  validates :bike_cc, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: true
end
