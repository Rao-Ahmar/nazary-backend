FactoryBot.define do
  factory :feedback_submission do
    user { nil }
    subject { "MyString" }
    message { "MyText" }
    status { 1 }
  end
end
