class PlannerReview < ApplicationRecord
  belongs_to :user
  belongs_to :planner, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :text, presence: true
  validates :user_id, uniqueness: { scope: :planner_id, message: "has already reviewed this planner" }
  validate :reviewer_is_traveler
  validate :target_is_planner

  private

  def reviewer_is_traveler
    errors.add(:user, "must be a traveler") unless user&.traveler?
  end

  def target_is_planner
    errors.add(:planner, "must be a planner") unless planner&.planner?
  end
end
