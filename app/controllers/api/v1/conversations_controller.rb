# REMOVED: messaging feature — Nazary v1
# All conversation controller functionality has been removed.
module Api
  module V1
    class ConversationsController < BaseController
      # def index
      #   conversations = current_user.conversations
      #     .includes(:participants, :messages, :trip)
      #     .order(updated_at: :desc)
      #   render json: conversations, each_serializer: ConversationSerializer, current_user: current_user
      # end
      #
      # def create
      #   participant = User.find(params[:participant_id])
      #   conversation = find_existing_conversation(participant)
      #   unless conversation
      #     conversation = Conversation.create!(trip_id: params[:trip_id])
      #     conversation.participants << [ current_user, participant ]
      #   end
      #   if params[:message].present?
      #     conversation.messages.create!(sender: current_user, body: params[:message])
      #   end
      #   render json: conversation, serializer: ConversationSerializer, current_user: current_user, status: :created
      # end
      #
      # private
      #
      # def find_existing_conversation(participant)
      #   current_user.conversations.joins(:participants)
      #     .where(conversation_participants: { user_id: participant.id })
      #     .first
      # end
    end
  end
end
