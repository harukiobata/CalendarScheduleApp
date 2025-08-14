FactoryBot.define do
  factory :mail_template do
    name { "MyString" }
    subject { "MyString" }
    body { "MyText" }
    user { nil }
  end
end
