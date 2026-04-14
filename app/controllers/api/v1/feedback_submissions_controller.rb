module Api
  module V1
    class FeedbackSubmissionsController < BaseController
      def create
        submission = current_user.feedback_submissions.new(feedback_params)
        if submission.save
          render json: { message: "Feedback submitted successfully" }, status: :created
        else
          render json: { error: submission.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      end

      private

      def feedback_params
        params.permit(:subject, :message)
      end
    end
  end
end
