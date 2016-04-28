FactoryGirl.define do
  factory :answer do
    question
    body "This is an answer to a very important question."

    factory :blank_answer do
      body ""
      question
    end
  end
end
