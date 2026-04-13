module Api
  module V1
    module Planner
      class BookingsController < Planner::BaseController
        def index
          bookings = Booking.where(trip: current_user.trips)
                            .includes(trip: { hero_image_attachment: :blob }, user: { avatar_attachment: :blob })
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
          NotificationService.create(
            user: booking.user,
            title: "Booking Confirmed!",
            body: "Your request to join #{booking.trip.title} has been confirmed",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )
          render json: booking, serializer: BookingSerializer, planner_view: true
        end

        def cancel
          booking = find_booking
          booking.cancelled!
          NotificationService.create(
            user: booking.user,
            title: "Booking Declined",
            body: "Your request to join #{booking.trip.title} was declined",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )
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
