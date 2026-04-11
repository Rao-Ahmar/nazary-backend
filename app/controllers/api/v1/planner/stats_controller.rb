module Api
  module V1
    module Planner
      class StatsController < Planner::BaseController
        def index
          trips = current_user.trips
          confirmed_bookings = Booking.confirmed.where(trip: trips)

          this_month = confirmed_bookings.where(created_at: Time.current.beginning_of_month..)
          last_month = confirmed_bookings.where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
          growth = if last_month.sum(:amount).positive?
            ((this_month.sum(:amount) - last_month.sum(:amount)) / last_month.sum(:amount) * 100).round
          else
            0
          end

          render json: {
            totalRevenue: confirmed_bookings.sum(:amount),
            activeTrips: trips.active.count,
            totalBookings: confirmed_bookings.count,
            avgRating: trips.joins(:reviews).average("reviews.rating")&.round(1) || 0.0,
            monthlyGrowth: growth
          }
        end
      end
    end
  end
end
