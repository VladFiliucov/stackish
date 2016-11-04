require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'guest ability' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin ability' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user ability' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question){ create(:question, user: user) }
    let(:other_users_question){ create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_users_answer){ create(:answer, user: other_user) }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should be_able_to :edit, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :update, create(:comment, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, user: other_user), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :destroy, create(:comment, user: user), user: user }
    it { should be_able_to :destroy, create(:subscription, user: user, question: question), user: user }
    it { should_not be_able_to :destroy, create(:comment, user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:subscription, user: other_user, question: question), user: user }

    it { should be_able_to :mark_best, answer }

    it { should be_able_to :change_rating, other_users_question }
    it { should_not be_able_to :change_rating, question }
    it { should be_able_to :withdraw_rating, question }
    it { should_not be_able_to :withdraw_rating, other_users_question }

    it { should be_able_to :change_rating, other_users_answer }
    it { should_not be_able_to :change_rating, answer }
    it { should be_able_to :withdraw_rating, answer }
    it { should_not be_able_to :withdraw_rating, other_users_answer }
  end
end
