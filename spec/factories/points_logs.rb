FactoryBot.define do
  factory :points_log do
    user { nil }
    points { 1 }
    reason { "MyString" }
    metadata { "" }
  end
end
