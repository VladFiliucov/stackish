FactoryGirl.define do
  factory :answer do
    body "This is an answer to a very important question."
    question
    user

    factory :blank_answer do
      body ""
      question
      user
    end
  end
end
