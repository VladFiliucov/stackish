FactoryGirl.define do
  factory :question do
    title "New Question"
    body "This is a realy long description beacuse it has to be 20 chars long."
    
    factory :question_with_answers do
      transient do
        answers_count 3
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: Question do
    title ""
    body ""
  end
end
