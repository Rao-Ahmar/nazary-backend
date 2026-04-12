class ItineraryPreset < ApplicationRecord
  belongs_to :user

  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { scope: :user_id, message: "has already been taken" }
  validates :days, presence: true
  validate :days_structure

  scope :ordered, -> { order(updated_at: :desc) }

  private

  def days_structure
    return if days.blank?

    unless days.is_a?(Array) && days.all? { |d| d.is_a?(Hash) && d["day"].present? && d["title"].present? }
      errors.add(:days, "must be an array of objects with day and title")
    end
  end
end
