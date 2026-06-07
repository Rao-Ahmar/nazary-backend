module Api
  module V1
    class TripRequestsController < BaseController
      before_action :require_traveler!, only: [ :create, :cancel ]

      def index
        requests = current_user.trip_requests.includes(:user, :planner).order(created_at: :desc)
        requests = requests.where(status: params[:status]) if params[:status].present?
        result = paginate(requests)
        render json: result[:data], each_serializer: TripRequestSerializer, meta: result[:meta]
      end

      def create
        trip_request = current_user.trip_requests.new(trip_request_params)

        if trip_request.save
          NotificationService.create(
            user: trip_request.planner,
            title: "New Trip Request",
            body: "#{current_user.name} sent you a trip request for #{trip_request.destination}",
            notification_type: :request_update,
            data: { trip_request_id: trip_request.id.to_s }
          )

          User.where(admin: true).find_each do |admin_user|
            NotificationService.create(
              user: admin_user,
              title: "New Trip Request",
              body: "New trip request from #{current_user.name} — advance payment pending",
              notification_type: :request_update,
              data: { trip_request_id: trip_request.id.to_s }
            )
          end

          render json: trip_request, serializer: TripRequestSerializer, status: :created
        else
          render json: { error: trip_request.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def cancel
        trip_request = current_user.trip_requests.find(params[:id])

        if trip_request.pending?
          trip_request.cancelled!
          render json: trip_request, serializer: TripRequestSerializer
        else
          render json: { error: "Only pending requests can be cancelled" }, status: :unprocessable_entity
        end
      end

      private

      def trip_request_params
        params.permit(:planner_id, :destination, :start_date, :end_date,
                       :seats, :category, :budget, :note)
      end
    end
  end
end
