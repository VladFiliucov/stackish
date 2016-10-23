shared_examples_for "Votable" do
  describe 'PATCH #change_rating' do

    let(:owner) { create(:user)}

    context 'guest user' do
      it "can not rate" do
        expect { guest_attempt_to_change_rating }.to_not change(entry.votes, :count)
        expect{response.status.to eq(403)}
      end
    end

    context 'author' do
      it 'can not rate own entry' do
        expect { author_attempt_to_change_rating }.to_not change(entry.votes, :count)
        expect{response.status.to eq(403)}
      end
    end

    context 'user' do
      login_user
      it 'can increase rating by one' do
        patch :change_rating, votable_hash.merge(user: user, rating: 1, format: :json)
        expect{ votable_object.current_rating.to eq(1)}
      end

      it 'can decrease rating by one' do
        patch :change_rating, votable_hash.merge(user: user, rating: -1, format: :json)
        expect{ votable_object.current_rating.to eq(-1) }
      end

      it 'can withdraw his rating' do
        patch :change_rating, votable_hash.merge(user: user, rating: -1, format: :json)
        patch :change_rating, votable_hash.merge( user: user, rating: 0, format: :json)
        expect{ votable_object.current_rating.to eq(0) }
      end

      it 'can not change rating by 2' do
        patch :change_rating, votable_hash.merge( user: user, rating: 1, format: :json)
        patch :change_rating, votable_hash.merge( user: user, rating: 1, format: :json)
        expect{ votable_object.current_rating.to eq(1) }
      end
    end
  end
end
