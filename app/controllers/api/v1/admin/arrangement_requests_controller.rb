module Api
  module V1
    module Admin
      class ArrangementRequestsController < BaseController
        def index
          requests = ArrangementRequest.includes(:traveler, :linked_trip).order(created_at: :desc)
          requests = requests.where(status: params[:status]) if params[:status].present?
          result = paginate(requests)
          render json: result[:data], each_serializer: ArrangementRequestSerializer, meta: result[:meta]
        end

        def update
          request = ArrangementRequest.find(params[:id])
          if request.update(admin_arrangement_params)
            render json: request, serializer: ArrangementRequestSerializer
          else
            render json: { error: request.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        private

        def admin_arrangement_params
          params.permit(:status, :linked_trip_id)
        end
      end
    end
  end
end
