module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: [:change_rating, :withdraw_rating]
    before_action :set_votable, only: [:change_rating, :withdraw_rating]
    before_action :rating_policy, only: [:change_rating, :withdraw_rating]
  end

  def change_rating
    rating = params[:rating]
    @votable.rate(current_user, rating)
    render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: rating }
  end

  def withdraw_rating
    @votable.withdraw_users_rating(current_user)
    render json: { model: model_klass.to_s.downcase, id: @votable.id }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def rating_policy
    return head(:forbidden) if !current_user || current_user.author?(@votable)
  end
end
