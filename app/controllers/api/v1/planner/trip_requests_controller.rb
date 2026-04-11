module Api
  module V1
    module Planner
      class TripRequestsController < Planner::BaseController
        def index
          requests = current_user.received_trip_requests.includes(:user, :planner).order(created_at: :desc)
          requests = requests.where(status: params[:status]) if params[:status].present?
          result = paginate(requests)
          render json: result[:data], each_serializer: TripRequestSerializer, meta: result[:meta]
        end

        def accept
          trip_request = current_user.received_trip_requests.find(params[:id])

          if trip_request.pending?
            trip_request.accepted!
            NotificationService.create(
              user: trip_request.user,
              title: "Request Accepted!",
              body: "#{current_user.name} accepted your trip request for #{trip_request.destination}",
              notification_type: :request_update,
              data: { trip_request_id: trip_request.id.to_s }
            )
            render json: trip_request, serializer: TripRequestSerializer
          else
            render json: { error: "Only pending requests can be accepted" }, status: :unprocessable_entity
          end
        end

        def reject
          trip_request = current_user.received_trip_requests.find(params[:id])

          if trip_request.pending?
            trip_request.rejected!
            NotificationService.create(
              user: trip_request.user,
              title: "Request Declined",
              body: "#{current_user.name} declined your trip request for #{trip_request.destination}",
              notification_type: :request_update,
              data: { trip_request_id: trip_request.id.to_s }
            )
            render json: trip_request, serializer: TripRequestSerializer
          else
            render json: { error: "Only pending requests can be rejected" }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
