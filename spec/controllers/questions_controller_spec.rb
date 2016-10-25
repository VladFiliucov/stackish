require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) {create(:question, user: user)}

  describe 'includes Voted' do
    it { expect(QuestionsController.ancestors.include? Voted).to eq(true) }
  end

  it_behaves_like "Votable" do
    let(:votable_object) { entry }
    let(:votable_hash) { { id: entry } }
    let(:entry) { create(:question, user: owner)}
    let(:guest_attempt_to_change_rating) { patch :change_rating, id: entry }
    let(:author_attempt_to_change_rating) { patch :change_rating, id: question, user: owner }
  end

  it_behaves_like "unauthorized entry" do
    let(:entry_params) { {question: attributes_for(:question)} }
  end

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
  end

  describe 'POST #create' do
    login_user
    context 'with valid attributes' do
      it 'saves new question to the database' do
        expect {post :create, question: attributes_for(:question)}.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'publishes to /questions channel' do
        expect(PrivatePub).to receive(:publish_to).with("/questions", any_args)
        post :create, question: attributes_for(:question)
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

      it 'does not publish to /questions channel' do
        expect(PrivatePub).to_not receive(:publish_to).with("/questions", any_args)
        post :create, question: attributes_for(:invalid_question)
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    context 'with valid attributes' do
      let(:another_question) { create(:question, user: @user) }

      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq(question)
      end

      it 'cahnges question attributes' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(question.title).to eq("New Question")
      end

      it 'renders update js template' do
        patch :update, id: another_question, question: { title: "This is a title for this question", body: "this is body for this question and it should be updated now"}, format: :js
        expect(response).to render_template(:update)
      end
    end

    context 'with invalid attributes' do
      before {  patch :update, id: question, question: {title: "another title", body: nil }, format: :js }

      it 'does not update question attributes' do
        question.reload
        expect(question.title).to eq("New Question")
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    context 'author' do
      let!(:question) { create(:question, user: @user) }

      it 'deletes question' do
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
        question.reload
        expect { delete :destroy, id: question}.to_not change(Question, :count)
      end
    end
  end
end
