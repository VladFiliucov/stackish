module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def current_rating
    votes.pluck(:rate_point).sum
  end

  def rate(user, rating)
    unless user.id == self.user_id
      new_rating = votes.find_or_create_by(user: user)
      new_rating.update(rate_point: rating)
    end
  end

  def has_users_rating?(user)
    votes.pluck(:user_id).include?(user.id)
  end

  def withdraw_users_rating(user)
    if self.has_users_rating?(user)
      rate(user, 0)
    end
  end
end
