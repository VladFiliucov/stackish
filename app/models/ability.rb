class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :edit, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user

    can :mark_best, Answer, question: { user_id: user.id }
    can :change_rating, [Question, Answer] { |votable| votable.user != user }
    can :withdraw_rating, [Question, Answer] { |votable| votable.user == user }
  end
end
