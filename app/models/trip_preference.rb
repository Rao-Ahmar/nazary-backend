class TripPreference < ApplicationRecord
  belongs_to :user
  belongs_to :followed_agency, class_name: "User", optional: true

  validates :user_id, uniqueness: true
  validate :budget_max_greater_than_min
  validate :followed_agency_must_be_planner

  private

  def budget_max_greater_than_min
    return unless budget_min.present? && budget_max.present?
    errors.add(:budget_max, "must be greater than budget min") if budget_max <= budget_min
  end

  def followed_agency_must_be_planner
    return unless followed_agency.present?
    errors.add(:followed_agency, "must be a planner") unless followed_agency.planner?
  end
end
