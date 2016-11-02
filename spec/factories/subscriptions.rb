FactoryGirl.define do
  factory :subscription do
    user
    question
  end

  factory :invalid_subscription, class: Subscription do
    user nil
    question nil
  end
end
