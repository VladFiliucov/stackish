FactoryGirl.define do
  factory :answer do
    body "This is an answer to a very important question."
    question

    factory :blank_answer do
      body ""
      question
    end
  end
end
