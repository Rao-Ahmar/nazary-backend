class CorporateTripRequest < ApplicationRecord
  belongs_to :user
  belongs_to :preferred_planner, class_name: "User", optional: true
  belongs_to :linked_trip, class_name: "Trip", optional: true

  enum :status, { pending: 0, in_review: 1, arranged: 2, rejected: 3 }

  validates :company_name, presence: true
  validates :estimated_people, presence: true, numericality: { greater_than: 0 }
  validate :contact_method_present

  private

  def contact_method_present
    if contact_email.blank? && contact_phone.blank?
      errors.add(:base, "At least one contact method (email or phone) is required")
    end
  end
end
