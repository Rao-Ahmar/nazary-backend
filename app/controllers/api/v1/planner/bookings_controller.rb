module Api
  module V1
    module Planner
      class BookingsController < Planner::BaseController
        def index
          bookings = Booking.where(trip: current_user.trips)
                            .includes(:trip, user: { avatar_attachment: :blob })
                            .order(created_at: :desc)

          bookings = bookings.where(status: params[:status]) if params[:status].present?
          bookings = bookings.where(trip_id: params[:trip_id]) if params[:trip_id].present?

          result = paginate(bookings)
          render json: result[:data], each_serializer: BookingSerializer, planner_view: true, meta: result[:meta]
        end

        def confirm
          booking = find_booking
          if booking.trip.seats_left <= 0
            render json: { error: "No seats available. Update total seats or cancel other bookings first." }, status: :unprocessable_entity
            return
          end
          booking.confirmed!
          render json: booking, serializer: BookingSerializer, planner_view: true
        end

        def cancel
          booking = find_booking
          booking.cancelled!
          render json: booking, serializer: BookingSerializer, planner_view: true
        end

        private

        def find_booking
          Booking.where(trip: current_user.trips).find(params[:id])
        end
      end
    end
  end
end
