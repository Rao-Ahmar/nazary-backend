class PaymentProofSerializer < ActiveModel::Serializer
  attributes :id, :booking_id, :reference_number, :amount, :method_used,
             :status, :admin_note, :screenshot_url, :verified_at, :created_at

  def id
    object.id.to_s
  end

  def booking_id
    object.booking_id.to_s
  end

  def screenshot_url
    object.screenshot.attached? ? Rails.application.routes.url_helpers.url_for(object.screenshot) : nil
  rescue StandardError
    nil
  end

  def verified_at
    object.verified_at&.iso8601
  end

  def created_at
    object.created_at.iso8601
  end
end
