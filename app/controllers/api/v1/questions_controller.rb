class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    @questions = Question.all
    # respond_with @questions.to_json(include: :answers)
    respond_with @questions, root: 'questions', each_serializer: QuestionCollectionSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    respond_with (@question = current_resource_owner.questions.create(question_params))
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
