class Notification < ApplicationRecord
  belongs_to :user

  enum :notification_type, {
    trip_reminder: 0,
    booking_update: 1,
    request_update: 2,
    review: 3,
    general: 4,
    bike_trip: 5,
    trip_update: 6,
    new_trip: 7,
    preference_match: 8
  }

  validates :title, presence: true
  validates :body, presence: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
end
