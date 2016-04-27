require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}

  describe '#GET index' do
    it 'populates array of answers for a question' do
      expect( create(:question_with_answers).answers.count ).to eq(3)
    end
  end
end
