FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'features', 'features_helper.rb')) }
    factory :attachment_for_answer do
      association :attachable, factory: :answer
    end
  end
end
