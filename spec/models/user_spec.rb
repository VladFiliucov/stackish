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

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'returns created user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: "nonexisting@user.com"}) }

        it 'creates new user' do
          expect {User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq(auth.info.email)
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end
      end

      context 'user is invalid' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: ""}) }
        it 'returns new user if user is not persisted' do
          expect(User.find_for_oauth(auth)).to be_a_new(User)
        end
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user)}
      User.send_daily_digest
    end
  end
end
