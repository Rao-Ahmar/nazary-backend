# REMOVED: messaging feature — Nazary v1
# All conversation-related functionality has been removed.
class Conversation < ApplicationRecord
  # belongs_to :trip, optional: true
  # has_many :conversation_participants, dependent: :destroy
  # has_many :participants, through: :conversation_participants, source: :user
  # has_many :messages, -> { order(:created_at) }, dependent: :destroy
  #
  # def last_message
  #   messages.last
  # end
  #
  # def unread_count_for(user)
  #   messages.where.not(sender_id: user.id).where(read: false).count
  # end
end
