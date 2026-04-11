class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:id])
    if conversation.participants.include?(current_user)
      stream_for conversation
    else
      reject
    end
  end
end
