module Api
  module V1
    module Admin
      class StatsController < BaseController
        def index
          render json: {
            total_bookings: Booking.count,
            pending_count: Booking.pending.count,
            approved_count: Booking.approved.count,
            payment_submitted_count: Booking.payment_submitted.count,
            confirmed_count: Booking.confirmed.count,
            cancelled_count: Booking.cancelled.count,
            rejected_count: Booking.rejected.count,
            total_revenue: Booking.confirmed.sum(:amount),
            recent_bookings: recent_bookings_json
          }
        end

        private

        def recent_bookings_json
          bookings = Booking.includes(
            trip: { hero_image_attachment: :blob },
            user: { avatar_attachment: :blob }
          ).order(created_at: :desc).limit(5)

          bookings.map { |b| AdminBookingSerializer.new(b).as_json }
        end
      end
    end
  end
end
