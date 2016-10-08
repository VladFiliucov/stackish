class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: User

  def index
    render nothing: true
  end
end
