module Api
  module V1
    module Admin
      class CorporateTripRequestsController < Admin::BaseController
        def index
          requests = CorporateTripRequest.includes(:user, :preferred_planner).order(created_at: :desc)
          requests = requests.where(status: params[:status]) if params[:status].present?
          result = paginate(requests)
          render json: result[:data], each_serializer: CorporateTripRequestSerializer, meta: result[:meta]
        end

        def update
          request = CorporateTripRequest.find(params[:id])
          previous_status = request.status

          if request.update(admin_corporate_trip_request_params)
            if request.status == "arranged" && previous_status != "arranged"
              user = request.user
              user.increment!(:corporate_trips_count)
              recalculate_corporate_level(user)
            end

            render json: request, serializer: CorporateTripRequestSerializer
          else
            render json: { error: request.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        private

        def admin_corporate_trip_request_params
          params.permit(:status, :linked_trip_id, :admin_note)
        end

        def recalculate_corporate_level(user)
          level = if user.corporate_trips_count >= 15
                    "gold"
                  elsif user.corporate_trips_count >= 7
                    "silver"
                  elsif user.corporate_trips_count >= 3
                    "bronze"
                  else
                    "none"
                  end
          user.update_column(:corporate_level, level)
        end
      end
    end
  end
end
