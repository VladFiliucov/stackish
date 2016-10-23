require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'includes Voted' do
    it { expect(AnswersController.ancestors.include? Voted).to eq(true) }
  end

  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}



  it_behaves_like "Votable" do
    let(:votable_object) { entry }
    let(:votable_hash) { { question_id: question, id: entry } }
    let(:entry) { create(:answer, question: question, user: owner) }
    let(:guest_attempt_to_change_rating) { patch :change_rating, question_id: question, id: entry }
    let(:author_attempt_to_change_rating) { patch :change_rating, question_id: question, id: entry, user: owner }
  end

  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'redirects to sign up page' do
        post :create, question_id: question, format: :js, answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'Logged in user' do
    login_user

    describe 'POST #create' do
      context 'with valid attributes' do
        let(:new_answer) { create(:answer, question: question) }

        it 'saves new answer to the database' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer), format: :js
          }.to change(question.answers, :count).by(1)
        end

        it 'adds new answer to cerrent user answers' do
          expect {
            post :create, question_id: question, user: user, answer: attributes_for(:answer), format: :js
          }.to change(@user.answers, :count).by(1)
        end


        it 'has best_answer set to false by default' do
          expect(new_answer).to_not be_best_answer
        end

        it 'render create template'  do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {post :create, question_id: question, answer: attributes_for(:blank_answer), format: :js}.to_not change(Answer, :count)
        end

        it 're-renders create template' do
          post :create, question_id: question, answer: attributes_for(:blank_answer), format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'PATCH #update' do
      login_user
      let(:answer) { create(:answer, question: question) }
      let(:another_answer) { create(:answer, question: question, user: @user) }

      it 'assings the requested answer to @answer', format: :js do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: another_answer, question_id: question, answer: { body: 'It has to be a really long body because i have length validation'}, format: :js
        another_answer.reload
        expect(another_answer.body).to eq 'It has to be a really long body because i have length validation'
      end

      context 'With Invalid attributes' do
        it 'does not updates answer' do
          patch :update, xhr: true, question_id: question, id: answer, answer: attributes_for(:blank_answer), format: :js
          expect(answer.body).not_to be_empty
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'author' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes question' do
        expect {delete :destroy, question_id: question, id: answer, format: :js}.to change(Answer, :count).by(-1)
      end

      it 'returns success status' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response.status).to eq(200)
      end
    end

    context 'not author' do
      login_user
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete answer' do
        expect { delete :destroy, question_id: question, id: answer }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #mark_best' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:not_owned_question) { create(:question, user: another_user) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: not_owned_question) }

    context 'Guest User' do
      it 'redirects to sign up page' do
        patch :mark_best, id: answer1, question_id: question
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'Not Author of question' do
      login_user
      it 'redirects to question page' do
        patch :mark_best, id: answer2, question_id: not_owned_question, user: another_user
        expect(response).to redirect_to question_path(not_owned_question)
      end
    end

    context 'Author of question' do
      before do
        sign_in(user)
      end

      it 'marks answer as best' do
        patch :mark_best, id: answer1, question_id: question, format: :js
        answer1.reload
        expect(answer1).to be_best_answer
      end

      it 'returns success status' do
        patch :mark_best, id: answer1, question_id: question, user: user, format: :js
        expect(response.status).to eq(200)
      end

      context 'acceptig another answer' do
        let!(:allready_accepted_answer) { create(:answer, question: question, best_answer?: true) }

        it 'will change previous marked best answer best_answer? attribute to false' do
          expect {
            patch :mark_best, id: answer1, question_id: question, user: user, format: :js
          }.to change{allready_accepted_answer.reload.best_answer?}.from(true).to(false)
        end
      end
    end
  end
end
