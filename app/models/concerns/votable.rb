module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def current_rating
    votes.pluck(:rate_point).sum
  end

  def rate(user, rating)
    new_rating = votes.find_or_create_by(user: user)
    new_rating.update(rate_point: rating)
  end
end
