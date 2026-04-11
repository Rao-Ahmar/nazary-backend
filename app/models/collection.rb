class Collection < ApplicationRecord
  has_one_attached :cover_image
  has_many :collection_trips, dependent: :destroy
  has_many :trips, through: :collection_trips

  validates :title, presence: true
end
