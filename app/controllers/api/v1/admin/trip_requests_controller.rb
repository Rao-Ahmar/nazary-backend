module Api
  module V1
    module Admin
      class TripRequestsController < BaseController
        def index
          requests = TripRequest.includes(:user, :planner).order(created_at: :desc)
          requests = requests.where(status: params[:status]) if params[:status].present?

          if params[:admin_approved].present?
            requests = requests.where(admin_approved: ActiveModel::Type::Boolean.new.cast(params[:admin_approved]))
          end

          result = paginate(requests)
          render json: result[:data], each_serializer: TripRequestSerializer, meta: result[:meta]
        end

        def approve
          trip_request = TripRequest.find(params[:id])

          if trip_request.admin_approved?
            render json: { error: "Already approved" }, status: :unprocessable_entity
            return
          end

          trip_request.update!(admin_approved: true)

          NotificationService.create(
            user: trip_request.user,
            title: "Request Approved",
            body: "Your trip request for #{trip_request.destination} has been approved. The planner can now review it.",
            notification_type: :request_update,
            data: { trip_request_id: trip_request.id.to_s }
          )

          NotificationService.create(
            user: trip_request.planner,
            title: "Trip Request Ready",
            body: "Trip request from #{trip_request.user.name} for #{trip_request.destination} is ready for review",
            notification_type: :request_update,
            data: { trip_request_id: trip_request.id.to_s }
          )

          render json: trip_request, serializer: TripRequestSerializer
        end

        def reject
          trip_request = TripRequest.find(params[:id])

          unless trip_request.pending?
            render json: { error: "Only pending requests can be rejected" }, status: :unprocessable_entity
            return
          end

          trip_request.rejected!

          NotificationService.create(
            user: trip_request.user,
            title: "Request Not Approved",
            body: "Your trip request for #{trip_request.destination} was not approved",
            notification_type: :request_update,
            data: { trip_request_id: trip_request.id.to_s }
          )

          render json: trip_request, serializer: TripRequestSerializer
        end
      end
    end
  end
end
