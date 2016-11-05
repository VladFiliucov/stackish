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
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :edit, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment, Subscription], user: user

    can :mark_best, Answer, question: { user_id: user.id }
    can :change_rating, [Question, Answer] { |votable| !user.author?(votable) }
    can :withdraw_rating, [Question, Answer] { |votable| user.author?(votable)}
    can :me, User, id: user.id
    can :all_except_current, User, id: user.id
  end
end
