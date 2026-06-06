module Api
  module V1
    class BookingsController < BaseController
      before_action :require_traveler!, only: [ :create, :index, :cancel ]

      def create
        trip = Trip.find(params[:trip_id])
        seats = (params[:seats] || 1).to_i
        advance_fee = (trip.price * seats * 0.01).ceil

        current_user.update(phone: params[:phone]) if params[:phone].present?

        booking = current_user.bookings.new(trip: trip, amount: advance_fee, seats: seats)

        if booking.save
          # Notify planner
          NotificationService.create(
            user: trip.host,
            title: "New Join Request",
            body: "#{current_user.name} wants to join #{trip.title} (#{seats} #{'seat'.pluralize(seats)}). Phone: #{current_user.phone || 'not provided'}",
            notification_type: :booking_update,
            data: { trip_id: trip.id.to_s, booking_id: booking.id.to_s }
          )

          # Notify admin(s)
          User.where(admin: true).where.not(id: trip.host.id).find_each do |admin|
            NotificationService.create(
              user: admin,
              title: "New Booking Request",
              body: "#{current_user.name} wants to join #{trip.title}",
              notification_type: :booking_update,
              data: { trip_id: trip.id.to_s, booking_id: booking.id.to_s }
            )
          end

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

      def payment_info
        booking = current_user.bookings.find(params[:id])

        if booking.cancelled? || booking.rejected?
          render json: { error: "Payment info is not available for this booking" }, status: :unprocessable_entity
          return
        end

        accounts = PaymentAccount.active
        render json: {
          booking: BookingSerializer.new(booking).as_json,
          payment_accounts: accounts.map { |a| PaymentAccountSerializer.new(a).as_json }
        }
      end

      def submit_payment_proof
        booking = current_user.bookings.find(params[:id])

        if booking.cancelled? || booking.rejected?
          render json: { error: "Payment proof cannot be submitted for this booking" }, status: :unprocessable_entity
          return
        end

        proof = booking.payment_proofs.new(payment_proof_params)

        if proof.save
          booking.payment_submitted!

          # Notify admin(s)
          User.where(admin: true).find_each do |admin|
            NotificationService.create(
              user: admin,
              title: "Payment Proof Received",
              body: "#{current_user.name} submitted payment proof for #{booking.trip.title}",
              notification_type: :booking_update,
              data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
            )
          end

          render json: booking, serializer: BookingSerializer, status: :created
        else
          render json: { error: proof.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private

      def payment_proof_params
        params.permit(:reference_number, :screenshot, :amount, :method_used)
      end
    end
  end
end
