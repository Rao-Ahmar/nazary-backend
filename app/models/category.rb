class Category < ApplicationRecord
  validates :label, presence: true, uniqueness: true
  validates :icon, presence: true
end
