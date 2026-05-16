module Api
  module V1
    module Admin
      class BookingsController < BaseController
        def index
          bookings = Booking.includes(
            :payment_proofs,
            trip: [ :host, { hero_image_attachment: :blob } ],
            user: { avatar_attachment: :blob }
          ).order(created_at: :desc)

          bookings = bookings.where(status: params[:status]) if params[:status].present?
          bookings = bookings.where(trip_id: params[:trip_id]) if params[:trip_id].present?

          if params[:from].present? || params[:to].present?
            bookings = bookings.where("bookings.created_at >= ?", params[:from]) if params[:from].present?
            bookings = bookings.where("bookings.created_at <= ?", params[:to]) if params[:to].present?
          end

          result = paginate(bookings)
          render json: result[:data], each_serializer: AdminBookingSerializer, meta: result[:meta]
        end

        def show
          booking = Booking.includes(:payment_proofs, trip: :host, user: { avatar_attachment: :blob }).find(params[:id])
          render json: booking, serializer: AdminBookingSerializer
        end

        def approve
          booking = Booking.find(params[:id])

          unless booking.pending?
            render json: { error: "Booking must be pending to approve" }, status: :unprocessable_entity
            return
          end

          booking.approved!

          NotificationService.create(
            user: booking.user,
            title: "Booking Approved!",
            body: "Your booking for #{booking.trip.title} is approved. Please submit payment to confirm your seat.",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end

        def reject
          booking = Booking.find(params[:id])

          unless booking.pending?
            render json: { error: "Booking must be pending to reject" }, status: :unprocessable_entity
            return
          end

          booking.update!(status: :rejected, admin_note: params[:admin_note])

          NotificationService.create(
            user: booking.user,
            title: "Booking Declined",
            body: "Your booking request for #{booking.trip.title} was declined. #{params[:admin_note]}".strip,
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end

        def verify_payment
          booking = Booking.find(params[:id])

          unless booking.payment_submitted?
            render json: { error: "Booking must have payment submitted to verify" }, status: :unprocessable_entity
            return
          end

          if booking.trip.seats_left <= 0
            render json: { error: "No seats available" }, status: :unprocessable_entity
            return
          end

          booking.confirmed!
          booking.payment_proofs.submitted.update_all(status: :verified, verified_at: Time.current)

          # Notify traveler
          NotificationService.create(
            user: booking.user,
            title: "Booking Confirmed!",
            body: "Your payment for #{booking.trip.title} has been verified. Your seat is confirmed!",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          # Notify planner
          NotificationService.create(
            user: booking.trip.host,
            title: "New Confirmed Booking",
            body: "#{booking.user.name} is confirmed for #{booking.trip.title}",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end

        def reject_payment
          booking = Booking.find(params[:id])

          unless booking.payment_submitted?
            render json: { error: "Booking must have payment submitted to reject payment" }, status: :unprocessable_entity
            return
          end

          booking.update!(status: :approved, admin_note: params[:admin_note])
          booking.payment_proofs.submitted.update_all(status: :rejected, admin_note: params[:admin_note])

          NotificationService.create(
            user: booking.user,
            title: "Payment Not Verified",
            body: "Your payment for #{booking.trip.title} could not be verified. Please resubmit. #{params[:admin_note]}".strip,
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end

        def confirm
          booking = Booking.find(params[:id])

          if booking.confirmed?
            render json: { error: "Booking is already confirmed" }, status: :unprocessable_entity
            return
          end

          if booking.trip.seats_left <= 0
            render json: { error: "No seats available" }, status: :unprocessable_entity
            return
          end

          booking.confirmed!

          NotificationService.create(
            user: booking.user,
            title: "Booking Confirmed!",
            body: "Your booking for #{booking.trip.title} has been confirmed",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          NotificationService.create(
            user: booking.trip.host,
            title: "New Confirmed Booking",
            body: "#{booking.user.name} is confirmed for #{booking.trip.title}",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end

        def cancel
          booking = Booking.find(params[:id])

          if booking.cancelled?
            render json: { error: "Booking is already cancelled" }, status: :unprocessable_entity
            return
          end

          booking.cancelled!

          NotificationService.create(
            user: booking.user,
            title: "Booking Cancelled",
            body: "Your booking for #{booking.trip.title} has been cancelled",
            notification_type: :booking_update,
            data: { trip_id: booking.trip_id.to_s, booking_id: booking.id.to_s }
          )

          render json: booking, serializer: AdminBookingSerializer
        end
      end
    end
  end
end
