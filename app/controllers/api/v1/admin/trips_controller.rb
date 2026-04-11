module Api
  module V1
    module Admin
      class TripsController < BaseController
        def index
          trips = Trip.includes(:host).order(created_at: :desc)
          trips = trips.where(status: params[:status]) if params[:status].present?
          result = paginate(trips)
          render json: result[:data], each_serializer: TripListSerializer, meta: result[:meta]
        end

        def cancel
          trip = Trip.find(params[:id])
          trip.update!(status: :cancelled)
          render json: { id: trip.id.to_s, status: "cancelled" }
        end
      end
    end
  end
end
