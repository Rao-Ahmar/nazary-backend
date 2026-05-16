class PaymentAccountSerializer < ActiveModel::Serializer
  attributes :id, :method_type, :account_title, :account_number, :bank_name, :is_active, :created_at

  def id
    object.id.to_s
  end

  def created_at
    object.created_at.iso8601
  end
end
