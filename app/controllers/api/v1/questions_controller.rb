class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @qestions = Question.all
    respond_with @qestions.to_json(include: :answers)
  end
end
