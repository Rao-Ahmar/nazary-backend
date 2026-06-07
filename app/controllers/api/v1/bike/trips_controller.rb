module Api
  module V1
    module Bike
      class TripsController < Bike::BaseController
        def index
          trips = Trip.active.where("'Bike' = ANY(tags)")
                      .includes(:bookings, hero_image_attachment: :blob, host: { avatar_attachment: :blob })
                      .order(created_at: :desc)
          trips = trips.where("start_date >= ?", params[:start_after]) if params[:start_after].present?
          result = paginate(trips)
          render json: result[:data], each_serializer: TripListSerializer, meta: result[:meta]
        end
      end
    end
  end
end
