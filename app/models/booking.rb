class Booking < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_many :payment_proofs, dependent: :destroy

  enum :status, { pending: 0, confirmed: 1, cancelled: 2, approved: 3, payment_submitted: 4, rejected: 5 }

  scope :active, -> { where(status: [:pending, :confirmed, :approved, :payment_submitted]) }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :user_id, uniqueness: { scope: :trip_id, message: "has already requested to join this trip" }
  validate :traveler_role
  validate :seats_available, on: :create

  private

  def traveler_role
    errors.add(:user, "must be a traveler") unless user&.traveler?
  end

  def seats_available
    return unless trip
    return unless seats.present? && seats > 0
    if trip.seats_left < seats
      errors.add(:base, "Not enough seats available (only #{trip.seats_left} left)")
    end
  end
end
