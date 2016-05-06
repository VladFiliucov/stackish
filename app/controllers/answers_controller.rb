class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :get_question, only: [:index, :new, :create, :show, :destroy]
  before_action :get_answer, only: [:destroy]
  before_action :check_ownership, only: [:destroy]
  after_action  :handle_ajax, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    flash.now[:notice] =  'Your answer was successfully posted.'
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

  def handle_ajax
    if request.xhr?
      flash.discard
    end
  end

  def check_ownership
    unless current_user.author?(@answer)
      respond_to do |format|
        format.html {redirect_to @question, notice: 'Not your entry'}
      end
    end
  end
end
