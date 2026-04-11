class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :notification_type, :data, :read, :created_at

  def id
    object.id.to_s
  end

  def created_at
    object.created_at.iso8601
  end
end
