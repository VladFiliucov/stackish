class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: [:index, :create]

  authorize_resource

  def index
    respond_with @question.answers, root: "answers", each_serializer: AnswerSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_resource_owner))
    # respond_with :api, :v1, :question, @answer
    # respond_with @answer
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
