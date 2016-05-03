require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe "Verify ownership with #author?" do
    let(:user) { create(:user)}
    let(:not_owner) { create(:user)}

    it "owner" do
      entry = create(:answer, body: "12345667899023423423423423423423", question_id: 1, user: user)
      expect(user.author?(entry)).to be true
    end

    it "not owner" do
      unauthorized_entry = create(:question, title: "A really good question", body: "12312312312312312312312312312", user: not_owner)
      expect(user.author?(unauthorized_entry)).to be false
    end
  end
end
