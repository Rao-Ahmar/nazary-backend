module Api
  module V1
    class PointsController < BaseController
      def me
        pair = current_user.free_trip_pair
        render json: {
          points: current_user.points,
          completedTripsCount: current_user.completed_trips_count,
          surpriseGiftEligible: current_user.surprise_gift_eligible?,
          freeTripEligible: current_user.free_trip_eligible?,
          freeTripPairName: pair&.name,
          referralCode: current_user.referral_code,
          referralsCount: current_user.referrals.count,
          referralBonusPoints: current_user.points_logs.where(reason: "referral_bonus").sum(:points)
        }
      end
    end
  end
end
