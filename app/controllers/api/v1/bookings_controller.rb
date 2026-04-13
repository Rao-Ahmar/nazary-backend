module Api
  module V1
    class BookingsController < BaseController
      before_action :require_traveler!, only: [ :create, :index, :cancel ]

      def create
        trip = Trip.find(params[:trip_id])
        booking = current_user.bookings.new(trip: trip, amount: trip.price)

        if booking.save
          NotificationService.create(
            user: trip.host,
            title: "New Join Request",
            body: "#{current_user.name} wants to join #{trip.title}. Phone: #{current_user.phone || 'not provided'}",
            notification_type: :booking_update,
            data: { trip_id: trip.id.to_s, booking_id: booking.id.to_s }
          )
          render json: booking, serializer: BookingSerializer, status: :created
        else
          render json: { error: booking.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      def index
        bookings = current_user.bookings.includes(:trip, :user).order(created_at: :desc)
        result = paginate(bookings)
        render json: result[:data], each_serializer: BookingSerializer, meta: result[:meta]
      end

      def show
        booking = Booking.find(params[:id])
        render json: booking, serializer: BookingSerializer
      end

      def cancel
        booking = current_user.bookings.find(params[:id])
        booking.cancelled!
        render json: booking, serializer: BookingSerializer
      end
    end
  end
end
