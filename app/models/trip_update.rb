class TripUpdate < ApplicationRecord
  belongs_to :trip
  belongs_to :editor, class_name: "User"

  validates :changes, presence: true
end
