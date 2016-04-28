class AnswersController < ApplicationController
  before_action :get_question, only: [:index, :new, :create, :show]

  def index
    @answers = @question.answers
  end

  def show
    @answer = @question.answers.find(params[:id])
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to question_path(@question.id)
    else
      render :new
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
