class PointsService
  TRIP_COMPLETION_POINTS = 100
  REFERRAL_BONUS_POINTS = 150
  SURPRISE_GIFT_MILESTONE = 5
  FREE_TRIP_MILESTONE = 10

  def self.award_trip_completion(user, trip)
    ActiveRecord::Base.transaction do
      user.points_logs.create!(
        points: TRIP_COMPLETION_POINTS,
        reason: "trip_completed",
        metadata: { trip_id: trip.id.to_s }
      )

      user.increment!(:points, TRIP_COMPLETION_POINTS)
      user.increment!(:completed_trips_count)

      check_milestones(user)
    end

    NotificationService.create(
      user: user,
      title: "Points Earned!",
      body: "You earned #{TRIP_COMPLETION_POINTS} points for completing a trip!",
      notification_type: :general,
      data: { trip_id: trip.id.to_s }
    )
  end

  def self.award_referral_bonus(referrer, referred_user, trip)
    # Guard: only award once per referred user
    return if referrer.points_logs.exists?(
      reason: "referral_bonus",
      metadata: { referred_user_id: referred_user.id.to_s }
    )

    ActiveRecord::Base.transaction do
      referrer.points_logs.create!(
        points: REFERRAL_BONUS_POINTS,
        reason: "referral_bonus",
        metadata: { referred_user_id: referred_user.id.to_s, trip_id: trip.id.to_s }
      )

      referrer.increment!(:points, REFERRAL_BONUS_POINTS)
    end

    NotificationService.create(
      user: referrer,
      title: "Referral Bonus!",
      body: "You earned #{REFERRAL_BONUS_POINTS} bonus points because #{referred_user.name} completed their first trip!",
      notification_type: :general,
      data: { referred_user_id: referred_user.id.to_s }
    )
  end

  def self.check_milestones(user)
    if user.completed_trips_count >= SURPRISE_GIFT_MILESTONE && !user.surprise_gift_eligible?
      user.update!(surprise_gift_eligible: true)
    end

    if user.completed_trips_count >= FREE_TRIP_MILESTONE && !user.free_trip_eligible?
      check_free_trip_pairing(user)
    end
  end

  # Free trip pairing: when user hits 10 trips, check if they can form a pair
  # with their referrer or one of their referrals who also has 10+ trips.
  # Both users in the pair become eligible. One-time only (skip if already paired).
  def self.check_free_trip_pairing(user)
    return if user.free_trip_pair_user_id.present?

    partner = nil

    # Case 1: user was referred → check if referrer has 10+ trips and isn't paired yet
    if user.referred_by.present?
      referrer = user.referred_by
      if referrer.completed_trips_count >= FREE_TRIP_MILESTONE && referrer.free_trip_pair_user_id.blank?
        partner = referrer
      end
    end

    # Case 2: user is a referrer → find first referral with 10+ trips who isn't paired yet
    if partner.nil?
      partner = user.referrals
                    .where("completed_trips_count >= ?", FREE_TRIP_MILESTONE)
                    .where(free_trip_pair_user_id: nil)
                    .first
    end

    return unless partner

    # Pair both users and mark eligible
    user.update!(free_trip_eligible: true, free_trip_pair_user_id: partner.id)
    partner.update!(free_trip_eligible: true, free_trip_pair_user_id: user.id) unless partner.free_trip_eligible?

    NotificationService.create(
      user: user,
      title: "Free Trip Eligible!",
      body: "You and #{partner.name} are now eligible for a free sponsored trip! Stay tuned for the lucky draw.",
      notification_type: :general,
      data: {}
    )

    NotificationService.create(
      user: partner,
      title: "Free Trip Eligible!",
      body: "You and #{user.name} are now eligible for a free sponsored trip! Stay tuned for the lucky draw.",
      notification_type: :general,
      data: {}
    )
  end

  private_class_method :check_milestones, :check_free_trip_pairing
end
