class ItineraryDay < ApplicationRecord
  belongs_to :trip

  validates :day, :title, :desc, presence: true

  default_scope { order(:day) }
end
