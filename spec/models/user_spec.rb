require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy)}
  it { should have_many(:authorizations).dependent(:destroy)}

  describe "Verify ownership with #author?" do
    let(:user) { create(:user)}
    let(:not_owner) { create(:user)}

    it "owner" do
      entry = create(:answer, question_id: 1, user: user)
      expect(user).to be_author(entry)
    end

    it "not owner" do
      unauthorized_entry = create(:question, title: "A really good question", user: not_owner)
      expect(user).to_not be_author(unauthorized_entry)
    end
  end


  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context 'user already has authorization' do
      it 'it returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'existing user' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect {User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect {User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
      end
    end
  end
end
