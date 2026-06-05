FactoryBot.define do
  factory :corporate_trip_request do
    user { nil }
    company_name { "MyString" }
    estimated_people { 1 }
    contact_email { "MyString" }
    contact_phone { "MyString" }
    special_notes { "MyText" }
    status { 1 }
    admin_note { "MyText" }
  end
end
