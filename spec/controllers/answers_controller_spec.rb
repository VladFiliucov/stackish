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

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer to the database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to tickets show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {post :create, question_id: question, answer: attributes_for(:blank_answer)}
      end

      it 're-renders new template' do
        post :create, question_id: question, answer: attributes_for(:blank_answer)
        expect(response).to render_template(:new)
      end
    end
  end
end
