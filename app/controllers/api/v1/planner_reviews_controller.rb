module Api
  module V1
    class PlannerReviewsController < BaseController
      skip_before_action :authenticate!, only: [ :index ]
      before_action :require_traveler!, only: [ :create ]

      def index
        planner = User.find(params[:user_id])
        reviews = planner.planner_reviews_received.includes(:user).order(created_at: :desc)
        result = paginate(reviews)
        render json: result[:data], each_serializer: PlannerReviewSerializer, meta: result[:meta]
      end

      def create
        planner = User.find(params[:planner_id])
        review = current_user.planner_reviews_given.new(
          planner: planner,
          rating: params[:rating],
          text: params[:text]
        )

        if review.save
          NotificationService.create(
            user: planner,
            title: "New Review",
            body: "#{current_user.name} left you a #{review.rating}-star review",
            notification_type: :review,
            data: { planner_review_id: review.id.to_s }
          )
          render json: review, serializer: PlannerReviewSerializer, status: :created
        else
          render json: { error: review.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end
    end
  end
end
