module Api
  module V1
    class ReviewsController < BaseController
      before_action :require_traveler!, only: [ :create ]

      def index
        trip = Trip.find(params[:trip_id])
        reviews = trip.reviews.includes(:user).order(created_at: :desc)
        result = paginate(reviews)
        render json: result[:data], each_serializer: ReviewSerializer, meta: result[:meta]
      end

      def create
        trip = Trip.find(params[:trip_id])
        review = current_user.reviews.new(
          trip: trip,
          rating: params[:rating],
          text: params[:text]
        )

        if review.save
          render json: review, serializer: ReviewSerializer, status: :created
        else
          render json: { error: review.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end
    end
  end
end
