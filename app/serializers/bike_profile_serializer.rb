class BikeProfileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :user_name, :user_avatar,
             :bike_model, :bike_cc, :experience_level, :bio

  def id
    object.id.to_s
  end

  def user_id
    object.user_id.to_s
  end

  def user_name
    object.user.name
  end

  def user_avatar
    object.user.avatar.attached? ? Rails.application.routes.url_helpers.url_for(object.user.avatar) : nil
  rescue StandardError
    nil
  end
end
