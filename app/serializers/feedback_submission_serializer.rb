class FeedbackSubmissionSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :subject, :message, :status, :created_at

  def id
    object.id.to_s
  end

  def name
    object.user.name
  end

  def email
    object.user.email
  end

  def created_at
    object.created_at.iso8601
  end
end
