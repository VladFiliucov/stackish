class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question
  before_action :set_subscribtion, only: :destroy
  before_action :check_ownership, only: :destroy

  respond_to :json

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create!(question_id: @question.id)
    if @subscription.save
      respond_with @subscription
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    respond_with @subscription.destroy
  end

  private

  def set_subscribtion
    @subscription = @question.subscriptions.find_by(user_id: current_user.id)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def check_ownership
    current_user.author?(@subscription)
  end
end
