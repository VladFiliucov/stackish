FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'superpassword1'
    password_confirmation 'superpassword1'
  end
end
