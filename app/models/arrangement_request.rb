class ArrangementRequest < ApplicationRecord
  belongs_to :traveler, class_name: "User"
  belongs_to :linked_trip, class_name: "Trip", optional: true

  enum :status, { pending: 0, in_review: 1, arranged: 2, rejected: 3 }

  validates :group_size, presence: true, numericality: { greater_than: 0 }
  validates :traveler, presence: true
  validate :traveler_must_be_traveler

  private

  def traveler_must_be_traveler
    errors.add(:traveler, "must be a traveler") if traveler && !traveler.traveler?
  end
end
