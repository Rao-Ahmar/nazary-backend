# REMOVED: messaging feature — Nazary v1
# All message-related functionality has been removed.
class Message < ApplicationRecord
  # belongs_to :conversation
  # belongs_to :sender, class_name: "User"
  # validates :body, presence: true
  # after_create_commit :broadcast_message
  #
  # private
  #
  # def broadcast_message
  #   ConversationChannel.broadcast_to(conversation, MessageSerializer.new(self).as_json)
  # end
end
