require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_many(:answers).dependent(:destroy)  }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
  it { expect(Question.ancestors.include? Commentable).to eq(true) }
  it { expect(Question.ancestors.include? Votable).to eq(true) }

  it do
    should validate_length_of(:title).
      is_at_least(7)
  end

  it do
    should validate_length_of(:body).
      is_at_least(10)
  end

  describe '#reputation' do
    let(:user) { create(:user) }
    subject { build(:question, user: user)}

    it 'should calculate reputation after creating' do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(Reputation).to_not receive(:calculate)
      subject.update(title: '123')
    end

    it 'should save user reputation' do
      allow(Reputation).to receive(:calculate).and_return(5)
      expect { subject.save! }.to change(user, :reputation).by(5)
    end
  end
end
