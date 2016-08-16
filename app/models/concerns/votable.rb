module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def current_rating
    votes.sum(:rate_point)
  end

  def rate(user, rating)
    unless user.id == self.user_id
      new_rating = votes.find_or_create_by(user: user)
      new_rating.update(rate_point: rating)
    end
  end

  def has_users_rating?(user)
    votes.exists?(user_id: user.id) if user
  end

  def withdraw_users_rating(user)
    if has_users_rating?(user)
      votes.where(user: user).destroy_all
    end
  end
end
