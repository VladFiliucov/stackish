class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :get_question, only: [:new, :create, :show, :destroy]
  before_action :get_answer, only: [:destroy]
  before_action :check_ownership, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    flash.now[:notice] =  'Your answer was successfully posted.'
  end

  def destroy
    @answer.destroy
    flash[:notice] = "Answer has been deleted"
  end

  def update
    @answer = Answer.find(params[:id])
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to(@answer, notice: 'Answer was successfully updated.') }
        format.json { respond_with_bip(@answer) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@answer) }
      end
    end
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
    unless current_user.author?(@answer)
      respond_to do |format|
        format.html {redirect_to @question, notice: 'Not your entry'}
      end
    end
  end
end
