class PaymentProof < ApplicationRecord
  belongs_to :booking

  has_one_attached :screenshot

  enum :status, { submitted: 0, verified: 1, rejected: 2 }

  validates :reference_number, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :method_used, presence: true
end
