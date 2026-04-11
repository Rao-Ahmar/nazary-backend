module Api
  module V1
    class CoupleRequestsController < BaseController
      def index
        requests = current_user.couple_requests.order(created_at: :desc)
        render json: requests, each_serializer: CoupleRequestSerializer
      end

      def create
        couple_request = current_user.couple_requests.new(couple_request_params)

        if couple_request.save
          render json: couple_request, serializer: CoupleRequestSerializer, status: :created
        else
          render json: { error: couple_request.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private

      def couple_request_params
        params.permit(:partner_name, :destination_preference, :travel_dates, :budget_range, :special_requests)
      end
    end
  end
end
