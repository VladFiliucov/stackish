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
  let(:entry) { WithVotable.create }

  describe 'increase rating' do
    it 'increases objects rate' do
      expect { entry.rate(user, 1)
      }.to change(entry.votes, :count).by(1)
      expect(entry.current_rating).to eq 1
    end
  end

  describe 'decrease rating' do
  end
end
