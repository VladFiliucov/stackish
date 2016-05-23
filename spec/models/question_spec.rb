require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_many(:answers).dependent(:destroy)  }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should have_many(:attachments).dependent(:destroy) }

  it do
    should validate_length_of(:title).
      is_at_least(7)
  end

  it do
    should validate_length_of(:body).
      is_at_least(10)
  end
end
