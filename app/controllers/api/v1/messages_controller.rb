# REMOVED: messaging feature — Nazary v1
# All message controller functionality has been removed.
module Api
  module V1
    class MessagesController < BaseController
      # before_action :set_conversation
      #
      # def index
      #   messages = @conversation.messages.includes(:sender).order(created_at: :desc)
      #   result = paginate(messages)
      #   render json: result[:data], each_serializer: MessageSerializer, meta: result[:meta]
      # end
      #
      # def create
      #   message = @conversation.messages.new(sender: current_user, body: params[:text])
      #   if message.save
      #     render json: message, serializer: MessageSerializer, status: :created
      #   else
      #     render json: { error: message.errors.full_messages.join(", ") }, status: :unprocessable_entity
      #   end
      # end
      #
      # def mark_read
      #   @conversation.messages
      #     .where.not(sender_id: current_user.id)
      #     .where(read: false)
      #     .update_all(read: true)
      #   head :no_content
      # end
      #
      # private
      #
      # def set_conversation
      #   @conversation = current_user.conversations.find(params[:conversation_id])
      # end
    end
  end
end
