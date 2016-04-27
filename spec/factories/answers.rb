FactoryGirl.define do
  factory :answer do
    body "This is an answer to a very important question."
    question
  end
end
