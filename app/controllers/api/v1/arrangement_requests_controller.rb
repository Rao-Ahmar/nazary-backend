module Api
  module V1
    class ArrangementRequestsController < BaseController
      before_action :require_traveler!, only: [ :create ]

      def create
        request = current_user.arrangement_requests_as_traveler.new(arrangement_params)
        if request.save
          render json: request, serializer: ArrangementRequestSerializer, status: :created
        else
          render json: { error: request.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def my_requests
        requests = current_user.arrangement_requests_as_traveler.order(created_at: :desc)
        result = paginate(requests)
        render json: result[:data], each_serializer: ArrangementRequestSerializer, meta: result[:meta]
      end

      private

      def arrangement_params
        params.permit(:preferred_destination, :travel_dates, :group_size,
                      :budget_min, :budget_max, :special_notes, :agency_id)
      end
    end
  end
end
