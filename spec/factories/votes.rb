FactoryGirl.define do
  factory :vote do
    user
    rate_point 1
    factory :question_rating do
      association :votable, factory: :question
    end

    factory :answer_rating do
      association :votable, factory: :answer
    end
  end
end
