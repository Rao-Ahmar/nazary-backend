module Api
  module V1
    module Admin
      class LuckyDrawController < BaseController
        def eligible
          # Eligible = has referrals AND has at least one booking with advance payment
          travelers = User.traveler
                         .joins(:referrals)
                         .joins(bookings: :payment_proofs)
                         .select("users.*, COUNT(DISTINCT referrals_users.id) AS referrals_count")
                         .group("users.id")
                         .order("referrals_count DESC")

          data = travelers.map do |traveler|
            friends = traveler.referrals.select(:id, :name, :email, :created_at).map do |friend|
              {
                id: friend.id.to_s,
                name: friend.name,
                email: friend.email,
                joined_at: friend.created_at.iso8601
              }
            end

            {
              id: traveler.id.to_s,
              name: traveler.name,
              email: traveler.email,
              avatar: traveler.avatar.attached? ? url_for(traveler.avatar) : nil,
              referral_code: traveler.referral_code,
              referrals_count: traveler.referrals_count.to_i,
              referred_friends: friends
            }
          end

          render json: { eligible_travelers: data }
        end
      end
    end
  end
end
