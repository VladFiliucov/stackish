class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question
  before_action :set_subscribtion, only: :destroy

  respond_to :json, :js

  authorize_resource

  def create
    @subscription = @question.subscriptions.create!(user: current_user)
    if @subscription.save
      respond_with @subscription, location: @question
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    respond_with @subscription.destroy, location: @question
  end

  private

  def set_subscribtion
    @subscription = @question.subscriptions.find_by(user_id: current_user.id)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
