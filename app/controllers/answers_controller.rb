class AnswersController < ApplicationController
  before_action :get_question, only: [:index, :new, :create, :show]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def create
    if current_user
      @answer = @question.answers.new(answer_params)
      @answer.user = current_user
      if @answer.save
        redirect_to @question
        flash[:notice] = 'Your answer was successfully posted.'
      else
        redirect_to @question
        flash[:notice] = ''
      end
    else
      redirect_to new_user_session_path
      flash[:notice] = 'sign in or sign up'
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
