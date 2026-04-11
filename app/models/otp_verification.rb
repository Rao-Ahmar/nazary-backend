class OtpVerification < ApplicationRecord
  validates :phone_number, presence: true, format: {
    with: /\A(\+92\d{10}|0\d{10})\z/,
    message: "must be a valid Pakistan phone number"
  }
  validates :code, presence: true, length: { is: 6 }

  scope :active, -> { where(verified: false).where("expires_at > ?", Time.current).where("attempts < 5") }

  def expired?
    expires_at < Time.current
  end

  def verify!(input_code)
    return false if expired? || verified? || attempts >= 5

    increment!(:attempts)

    if code == input_code
      update!(verified: true)
      true
    else
      false
    end
  end

  def self.generate_for(phone_number)
    where(phone_number: phone_number, verified: false).update_all(verified: true)
    create!(
      phone_number: phone_number,
      code: rand(100000..999999).to_s,
      expires_at: 5.minutes.from_now
    )
  end
end
