FactoryGirl.define do
  factory :comment do
    body "This is a valid comment to find out details"

    user

    factory :questions_comment do
      association :commentable, factory: :question
    end

    factory :answers_comment do
      association :commentable, factory: :answer
    end

    factory :blank_comment do
      body ""

      user
    end
  end
end
