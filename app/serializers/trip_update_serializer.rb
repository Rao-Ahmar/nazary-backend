class TripUpdateSerializer < ActiveModel::Serializer
  attributes :id, :changes, :editor_name, :created_at

  def id
    object.id.to_s
  end

  def editor_name
    object.editor&.name || "Unknown"
  end

  def created_at
    object.created_at.iso8601
  end
end
