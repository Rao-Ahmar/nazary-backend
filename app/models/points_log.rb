class PointsLog < ApplicationRecord
  belongs_to :user

  validates :points, presence: true
  validates :reason, presence: true
end
