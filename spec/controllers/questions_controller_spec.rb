require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before {get :show, id: question}

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'render show template' do
      expect(response).to render_template(:show)
    end

    it 'sets new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    login_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders template new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    login_user

    before { get :edit, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders template edit' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    login_user
    context 'with valid attributes' do
      it 'saves new question to the database' do
        expect {post :create, question: attributes_for(:question)}.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {post :create, question: attributes_for(:invalid_question)}.to_not change(Question, :count)
      end

      it 're-renders new template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq(question)
      end

      it 'cahnges question attributes' do
        patch :update, id: question, question: { title: "new question", body: "body must be at least 20 chars long omg!!" }
        question.reload
        expect(question.title).to eq("new question")
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid attributes' do
      before {  patch :update, id: question, question: {title: "another title", body: nil } }

      it 'does not update question attributes' do
        question.reload
        expect(question.title).to eq("New Question")
      end

      it 'renders #edit' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'author' do
      let(:question) { create(:question, user: @user) }

      it 'deletes question' do
        question
        expect {delete :destroy, id: question}.to change(Question, :count).by(-1)
      end

      it 'redirects to index template' do
        delete :destroy, id: question
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'not author' do
      let(:owner) { create(:user)}
      let(:question) { create(:question, user: owner)}

      it 'does not delete question' do
        expect { delete :destroy, id: question}.to_not change(Question, :count)
      end
    end
  end
end
