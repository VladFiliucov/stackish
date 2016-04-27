require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}

  describe 'GET #index' do
    it 'populates array of answers for a question' do
      expect( create(:question_with_answers).answers.count ).to eq(3)
    end
  end

  describe 'GET #new' do
    before { get :new, question_id: question.id}

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

  end
end
