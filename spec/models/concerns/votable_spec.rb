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

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:and_another_user) { create(:user) }
  let(:yet_another_user) { create(:user) }
  let(:entry) { WithVotable.create }

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
end
