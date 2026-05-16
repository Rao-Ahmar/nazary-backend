class PaymentAccount < ApplicationRecord
  enum :method_type, { jazzcash: 0, easypaisa: 1, bank_transfer: 2 }

  validates :method_type, presence: true
  validates :account_title, presence: true
  validates :account_number, presence: true
  validates :bank_name, presence: true, if: :bank_transfer?

  scope :active, -> { where(is_active: true) }
end
