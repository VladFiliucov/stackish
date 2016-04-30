FactoryGirl.define do
  factory :question do
    title "New Question"
    body "This is a realy long description beacuse it has to be 20 chars long."
    user
  end

  factory :invalid_question, class: Question do
    title ""
    body ""
    user nil
  end
end
