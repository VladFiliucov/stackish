class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:index, :new, :create, :show, :destroy]
  before_action :get_answer, only: [:destroy]
  before_action :check_ownership, only: [:destroy]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice:  'Your answer was successfully posted.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@question)
    flash[:notice] = "Answer has been deleted"
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_ownership
    unless current_user && current_user.author?(@answer)
      respond_to do |format|
        format.html {redirect_to @question, notice: 'Not your entry'}
      end
    end
  end
end
