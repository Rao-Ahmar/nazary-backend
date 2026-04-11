class TripRequest < ApplicationRecord
  belongs_to :user
  belongs_to :planner, class_name: "User"

  enum :status, { pending: 0, accepted: 1, rejected: 2, cancelled: 3 }

  validates :destination, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validate :end_date_after_start_date
  validate :user_is_traveler
  validate :planner_is_planner

  private

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def user_is_traveler
    errors.add(:user, "must be a traveler") unless user&.traveler?
  end

  def planner_is_planner
    errors.add(:planner, "must be a planner") unless planner&.planner?
  end
end
