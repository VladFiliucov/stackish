FactoryGirl.define do
  factory :question do
    sequence(:title) {|n| "Question number #{n}"}
    body "This is a realy long description beacuse it has to be 20 chars long."
  end
end
