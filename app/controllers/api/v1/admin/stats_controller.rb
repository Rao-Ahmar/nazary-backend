module Api
  module V1
    module Admin
      class StatsController < BaseController
        def index
          counts_by_status = Booking.group(:status).count
          total = counts_by_status.values.sum

          render json: {
            total_bookings: total,
            pending_count: counts_by_status["pending"] || 0,
            approved_count: counts_by_status["approved"] || 0,
            payment_submitted_count: counts_by_status["payment_submitted"] || 0,
            confirmed_count: counts_by_status["confirmed"] || 0,
            cancelled_count: counts_by_status["cancelled"] || 0,
            rejected_count: counts_by_status["rejected"] || 0,
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
