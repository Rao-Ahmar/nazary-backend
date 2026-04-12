class Trip < ApplicationRecord
  belongs_to :host, class_name: "User", foreign_key: :user_id
  belongs_to :source_trip, class_name: "Trip", optional: true
  has_many :recurring_instances, class_name: "Trip", foreign_key: :source_trip_id, dependent: :nullify

  has_one_attached :hero_image
  has_many_attached :gallery

  has_many :itinerary_days, -> { order(:day) }, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :collection_trips, dependent: :destroy
  has_many :collections, through: :collection_trips
  has_many :conversations
  has_many :trip_updates, dependent: :destroy

  enum :status, { draft: 0, active: 1, completed: 2, cancelled: 3 }
  enum :trip_type, { casual: 0, family: 1, bike_trip: 2, couple_trip: 3 }, prefix: true

  validates :title, :description, :location, :price, :duration,
            :start_date, :end_date, :total_seats, presence: true
  validate :end_date_after_start_date
  validate :start_date_not_in_past, on: :create
  validate :recurring_rule_structure

  scope :upcoming, -> { where("start_date >= ?", Date.current) }
  scope :by_date_range, ->(from, to) {
    scope = all
    scope = scope.where("start_date >= ?", from) if from.present?
    scope = scope.where("start_date <= ?", to) if to.present?
    scope
  }
  scope :by_host, ->(host_id) { where(user_id: host_id) }
  scope :featured, -> { active.where("start_date >= ?", Date.current).order(start_date: :asc).limit(10) }
  scope :by_category, ->(tag) { where("? = ANY(tags)", tag) }
  scope :by_trip_type, ->(type) { where(trip_type: type) }
  scope :premium, -> { where(is_premium: true) }
  scope :recurring, -> { where(recurring_enabled: true) }
  scope :by_price_range, ->(min, max) {
    scope = all
    scope = scope.where("price >= ?", min) if min.present?
    scope = scope.where("price <= ?", max) if max.present?
    scope
  }

  before_save :set_premium_flag

  include PgSearch::Model
  pg_search_scope :search_by_text,
    against: [ :title, :location, :description ],
    using: { tsearch: { prefix: true } }

  def seats_left
    total_seats - bookings.confirmed.count
  end

  def average_rating
    reviews.average(:rating)&.round(1) || 0.0
  end

  def duration_in_days
    return 1 unless start_date && end_date
    (end_date - start_date).to_i
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def start_date_not_in_past
    return unless start_date
    errors.add(:start_date, "cannot be in the past") if start_date < Date.current
  end

  def set_premium_flag
    self.is_premium = true if trip_type_bike_trip? || trip_type_couple_trip?
  end

  def recurring_rule_structure
    if recurring_enabled? && recurring_rule.blank?
      errors.add(:recurring_rule, "is required when recurring is enabled")
      return
    end
    return unless recurring_enabled? && recurring_rule.present?

    unless recurring_rule.is_a?(Hash) &&
           recurring_rule["day_of_week"].is_a?(Integer) &&
           (0..6).cover?(recurring_rule["day_of_week"]) &&
           recurring_rule["hour"].is_a?(Integer) &&
           (0..23).cover?(recurring_rule["hour"])
      errors.add(:recurring_rule, "must include day_of_week (0-6) and hour (0-23)")
    end
  end
end
