FactoryBot.define do
  factory :user do
    user_firstname { "MyString" }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
