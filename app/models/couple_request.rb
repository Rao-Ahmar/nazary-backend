class CoupleRequest < ApplicationRecord
  belongs_to :user
  belongs_to :linked_trip, class_name: "Trip", optional: true

  enum :status, { pending: 0, reviewing: 1, arranged: 2, rejected: 3 }

  validates :partner_name, presence: true
  validates :destination_preference, presence: true
  validates :travel_dates, presence: true
  validates :budget_range, presence: true
end
