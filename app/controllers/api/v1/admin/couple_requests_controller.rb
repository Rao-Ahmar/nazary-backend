module Api
  module V1
    module Admin
      class CoupleRequestsController < Admin::BaseController
        def index
          requests = CoupleRequest.includes(:user, :linked_trip).order(created_at: :desc)
          result = paginate(requests)
          render json: result[:data], each_serializer: CoupleRequestSerializer, meta: result[:meta]
        end

        def update
          couple_request = CoupleRequest.find(params[:id])

          if couple_request.update(admin_couple_request_params)
            render json: couple_request, serializer: CoupleRequestSerializer
          else
            render json: { error: couple_request.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        private

        def admin_couple_request_params
          params.permit(:status, :linked_trip_id)
        end
      end
    end
  end
end
