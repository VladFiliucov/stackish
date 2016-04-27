class AnswersController < ApplicationController
  before_action :get_question, only: [:index]

  def index
    @answers = @question.answers
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end
end
