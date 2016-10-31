require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should validate_presence_of(:body)}
  it { should validate_presence_of(:question_id)}
  it { should validate_presence_of(:user_id)}
  it { should accept_nested_attributes_for :attachments }
  it { expect(Answer.ancestors.include? Commentable).to eq(true) }
  it { expect(Answer.ancestors.include? Votable).to eq(true) }

  it do
    should validate_length_of(:body).
      is_at_least(20)
  end


  describe '#mark_best!' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    context 'without best answer' do
      it 'displays answers in default order' do
        expect(question.answers.order(best_answer?: :desc)).to be == [answer1, answer2]
      end
    end

    context 'with best answer' do
      let!(:best_answer) { create(:answer, question: question, best_answer?: true) }

      it 'displays answers with best standing first in order' do
        expect(question.answers.first).to be == best_answer
      end

      context 'new best answer' do
        it 'resets previous best answers best_answer? attribute to false' do
          answer2.mark_best!
          best_answer.reload
          expect(best_answer.best_answer?).to be false
        end

        it 'sets best_answer? for the new best_answer to true' do
          expect{answer2.mark_best!}.to change{answer2.best_answer?}.from(false).to(true)
        end
      end
    end
  end

  describe '#reputation' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:answer, user: user, question: question) }

    it 'should calculate reputation after creating' do
      expect(CalculateReputationJob).to receive(:perform_later).with(subject)
      subject.save!
    end

    it 'should not calculate reputation after update' do
      subject.save!
      expect(CalculateReputationJob).to_not receive(:perform_now)
      subject.update(body: '123')
    end
  end
end
