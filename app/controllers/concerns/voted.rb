module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: :change_rating
    before_action :set_votable, only: :change_rating
    before_action :rating_policy, only: :change_rating
  end

  def change_rating
    rating = params[:rating]
    @votable.rate(current_user, rating)
    render json: { id: @votable.id, rate_point: rating }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def rating_policy
    render nothing: true, status: 403 if !current_user || current_user.author?(@votable)
  end
end
