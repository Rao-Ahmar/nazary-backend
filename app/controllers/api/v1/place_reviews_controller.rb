module Api
  module V1
    class PlaceReviewsController < BaseController
      skip_before_action :authenticate!, only: [ :index ]

      def index
        place = Place.find(params[:place_id])
        reviews = place.place_reviews.includes(:user).order(created_at: :desc)
        result = paginate(reviews)
        render json: result[:data], each_serializer: PlaceReviewSerializer, meta: result[:meta]
      end

      def create
        place = Place.find(params[:place_id])
        review = current_user.place_reviews.new(
          place: place,
          rating: params[:rating],
          text: params[:text]
        )

        if review.save
          render json: review, serializer: PlaceReviewSerializer, status: :created
        else
          render json: { error: review.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end
    end
  end
end
