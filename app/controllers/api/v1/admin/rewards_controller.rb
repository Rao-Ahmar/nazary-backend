module Api
  module V1
    module Admin
      class RewardsController < BaseController
        def index
          users = User.where("surprise_gift_eligible = ? OR free_trip_eligible = ?", true, true)

          if params[:milestone] == "5"
            users = users.where(surprise_gift_eligible: true)
          elsif params[:milestone] == "10"
            users = users.where(free_trip_eligible: true)
          end

          result = paginate(users.includes(:free_trip_pair).order(completed_trips_count: :desc))
          render json: result[:data], each_serializer: RewardUserSerializer, meta: result[:meta]
        end

        def mark_gift_sent
          user = User.find(params[:id])
          user.update!(surprise_gift_sent: true)
          render json: { id: user.id.to_s, surprise_gift_sent: true }
        end

        def mark_free_trip_arranged
          user = User.find(params[:id])
          user.update!(free_trip_arranged: true)
          render json: { id: user.id.to_s, free_trip_arranged: true }
        end
      end
    end
  end
end
