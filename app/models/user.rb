class User < ApplicationRecord
  has_secure_password validations: false
  validates :password, presence: true, on: :create, unless: :google_uid?

  enum :role, { traveler: 0, planner: 1 }

  has_one_attached :avatar
  has_one_attached :agency_logo
  has_one_attached :cover_photo

  # Planner associations
  has_many :trips, dependent: :destroy
  has_many :received_bookings, through: :trips, source: :bookings

  # Traveler associations
  has_many :bookings, dependent: :destroy
  has_many :booked_trips, through: :bookings, source: :trip
  has_many :reviews, dependent: :destroy

  # Trip Requests
  has_many :trip_requests, dependent: :destroy
  has_many :received_trip_requests, class_name: "TripRequest", foreign_key: :planner_id, dependent: :destroy

  # Notifications
  has_many :notifications, dependent: :destroy

  # Planner Reviews
  has_many :planner_reviews_given, class_name: "PlannerReview", dependent: :destroy
  has_many :planner_reviews_received, class_name: "PlannerReview", foreign_key: :planner_id, dependent: :destroy

  # Place Reviews
  has_many :place_reviews, dependent: :destroy

  # Referrals
  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referrals, class_name: "User", foreign_key: :referred_by_user_id

  # Free trip pair
  belongs_to :free_trip_pair, class_name: "User", optional: true

  # Bike Profile
  has_one :bike_profile, dependent: :destroy

  # Arrangement Requests (traveler)
  has_many :arrangement_requests_as_traveler, class_name: "ArrangementRequest", foreign_key: :traveler_id, dependent: :destroy

  # Couple Requests (traveler)
  has_many :couple_requests, dependent: :destroy

  # Trip Preferences
  has_one :trip_preference, dependent: :destroy

  # Itinerary Presets
  has_many :itinerary_presets, dependent: :destroy

  # Feedback Submissions
  has_many :feedback_submissions, dependent: :destroy

  # Points
  has_many :points_logs, dependent: :destroy

  # Payment Proofs (through bookings)
  has_many :payment_proofs, through: :bookings

  # Scopes
  scope :active, -> { where(deactivated: false) }
  scope :verified_planners, -> { where(role: :planner, verified: true, deactivated: false) }

  # REMOVED: messaging feature — Nazary v1
  # has_many :conversation_participants, dependent: :destroy
  # has_many :conversations, through: :conversation_participants
  # has_many :sent_messages, class_name: "Message", foreign_key: :sender_id

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true
  validates :phone, format: {
    with: /\A(\+92\d{10}|0\d{10})\z/,
    message: "must be a valid Pakistan phone number (e.g. +923001234567 or 03001234567)"
  }, allow_blank: true
  validates :agency_name_normalized, uniqueness: {
    message: "This agency name is already taken. Please use a different name."
  }, allow_nil: true
  validates :slug, uniqueness: true, allow_nil: true

  before_validation :normalize_agency_name, if: -> { planner? && agency_name.present? && agency_name_changed? }
  before_validation :generate_slug_from_agency_name, if: -> { planner? && agency_name.present? && agency_name_changed? }
  before_create :generate_referral_code
  before_save :downcase_email

  def profile_completed?
    if planner?
      agency_name.present? && phone.present? && agency_tagline.present? && avatar.attached?
    else
      phone.present?
    end
  end

  def premium?
    premium
  end

  def notifications_enabled?
    notifications_enabled
  end

  def average_planner_rating
    planner_reviews_received.average(:rating)&.to_f&.round(1) || 0.0
  end

  def generate_password_reset_token!
    self.password_reset_token = SecureRandom.urlsafe_base64(32)
    self.password_reset_sent_at = Time.current
    save!
    password_reset_token
  end

  def password_reset_valid?
    password_reset_sent_at.present? && password_reset_sent_at > 2.hours.ago
  end

  def clear_password_reset!
    update!(password_reset_token: nil, password_reset_sent_at: nil)
  end

  def generate_refresh_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(refresh_token: token)
    token
  end

  def nazary_url
    "nazary.pk/explore/#{slug}" if slug.present?
  end

  def social_verified?
    instagram_verified? || tiktok_verified?
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def normalize_agency_name
    self.agency_name_normalized = agency_name.strip.downcase
  end

  def generate_referral_code
    loop do
      self.referral_code = SecureRandom.alphanumeric(8).upcase
      break unless User.exists?(referral_code: referral_code)
    end
  end

  def generate_slug_from_agency_name
    base_slug = agency_name.strip.downcase
                           .gsub(/[^a-z0-9\s-]/, "")
                           .gsub(/\s+/, "-")
                           .gsub(/-+/, "-")
                           .gsub(/^-|-$/, "")
    candidate = base_slug
    counter = 1
    while User.where(slug: candidate).where.not(id: id).exists?
      candidate = "#{base_slug}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
