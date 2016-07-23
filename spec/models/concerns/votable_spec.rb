require 'rails_helper'

RSpec.describe Votable do
  with_model :WithVotable do
    table do |t|
      t.references :user
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:and_another_user) { create(:user) }
  let(:yet_another_user) { create(:user) }
  let(:entry) { WithVotable.create(user: author) }

  describe '#rate' do
    it 'decreases objects rate' do
      expect {
        entry.rate(user, -1)
      }.to change(entry.votes, :count).by(1)
      expect(entry.current_rating).to eq(-1)
    end

    it 'increases objects rate' do
      expect { entry.rate(user, 1)
      }.to change(entry.votes, :count).by(1)
      expect(entry.current_rating).to eq(1)
    end

    it 'updates rating if user exists' do
      entry.rate(user, 1)
      expect {
        entry.rate(user, -1)
      }.to_not change(entry.votes, :count)
      expect(entry.current_rating).to eq(-1)
    end

    describe 'author of entry' do
      it 'can not rate own entry' do
        expect{
          entry.rate(author, 1)
        }.to_not change(entry.votes, :count)
      end
    end
  end

  describe '#current_rating' do
    it 'calculates current rating properly' do
      entry.rate(user, 1)
      entry.rate(another_user, 1)
      entry.rate(yet_another_user, 1)
      entry.rate(and_another_user, -1)
      expect(entry.votes.count).to eq(4)
      expect(entry.current_rating).to eq(2)
    end
  end

  describe '#has_users_rating?' do
    it 'returns true if user rated current entry' do
      entry.rate(user, 1)
      expect(entry).to have_users_rating(user)
    end

    it 'returns false if user has not rated current entry' do
      expect(entry).to_not have_users_rating(user)
    end
  end

  describe '#withdraw_users_rating' do
    it 'resets rating' do
      entry.rate(user, 1)
      expect {
        entry.withdraw_users_rating(user).to change(entry.current_rating).from(1).to(0)
      }
    end
  end
end
