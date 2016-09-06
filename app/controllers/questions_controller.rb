class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:destroy]
  before_action :build_answer, only: :show

  respond_to :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.order(best_answer?: :desc)
    respond_with @question
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.save
      PrivatePub.publish_to("/questions", question: @question.to_json, users_email: @question.user.email.to_json)
    end
    respond_with @question
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = "Question has been updated!"
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def check_ownership
    current_user.author?(@question)
  end
end
