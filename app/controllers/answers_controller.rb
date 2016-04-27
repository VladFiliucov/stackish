class AnswersController < ApplicationController
  before_action :get_question, only: [:index, :new]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end
end
