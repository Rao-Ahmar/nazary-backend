class TripUpdate < ApplicationRecord
  belongs_to :trip
  belongs_to :editor, class_name: "User"

  validates :field_changes, presence: true
end
