class MessageSerializer < ActiveModel::Serializer
  attributes :id, :conversation_id, :sender_id, :text, :created_at, :read

  def id
    object.id.to_s
  end

  def conversation_id
    object.conversation_id.to_s
  end

  def sender_id
    object.sender_id.to_s
  end

  def text
    object.body
  end

  def created_at
    object.created_at.iso8601
  end
end
