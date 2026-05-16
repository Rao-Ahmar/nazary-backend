module Api
  module V1
    class CorporateTripRequestsController < BaseController
      def index
        requests = current_user.corporate_trip_requests.order(created_at: :desc)
        result = paginate(requests)
        render json: result[:data], each_serializer: CorporateTripRequestSerializer, meta: result[:meta]
      end

      def create
        request = current_user.corporate_trip_requests.new(corporate_trip_request_params)

        if request.save
          render json: request, serializer: CorporateTripRequestSerializer, status: :created
        else
          render json: { error: request.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private

      def corporate_trip_request_params
        params.permit(:company_name, :estimated_people, :contact_email, :contact_phone,
                      :special_notes, :preferred_planner_id)
      end
    end
  end
end
