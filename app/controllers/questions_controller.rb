class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
    @answers = @question.answers.order(best_answer?: :desc)
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.create(question_params)
    if @question.save
      PrivatePub.publish_to("/questions", question: @question.to_json, users_email: @question.user.email.to_json)
      redirect_to @question
      flash[:notice] = "Your question was successfully posted."
    else
      render :new
    end
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
    @question.destroy
    redirect_to questions_path
    flash[:notice] = "Question has been deleted."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def check_ownership
    current_user.author?(@question)
  end
end
