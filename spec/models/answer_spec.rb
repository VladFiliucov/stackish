require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body)}
  it { should belong_to(:question) }

  it do
    should validate_length_of(:body).
      is_at_least(20)
  end

  it do
    should belong_to(:question).
      with_foreign_key('question_id')
  end
end
