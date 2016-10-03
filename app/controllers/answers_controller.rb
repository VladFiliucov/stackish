class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :mark_best]
  before_action :get_question, only: [:create, :update, :destroy, :mark_best]
  before_action :get_answer, only: [:update, :destroy, :mark_best]
  before_action :check_ownership, only: [:destroy]
  before_action :check_if_can_mark_best, only: [:mark_best]

  respond_to :js

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    @answer.save
    respond_with(@answer, location: @question)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = "Answer has been updated"
    else
      render status: :unprocessable_entity
    end
  end

  def mark_best
    @answers = @question.answers
    @answer.mark_best!
    flash[:notice] = "You have picked best answer!"
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def get_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def check_ownership
    unless current_user.author?(@answer)
      respond_to do |format|
        format.html {redirect_to @question, notice: 'Not your entry'}
      end
    end
  end

  def check_if_can_mark_best
    unless current_user.author?(@answer.question)
      respond_to do |format|
        format.html {redirect_to @question, notice: 'Not your entry'}
      end
    end
  end
end
