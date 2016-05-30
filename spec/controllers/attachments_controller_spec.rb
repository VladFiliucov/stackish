require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe "GET #destroy" do
    context "Not owner" do
      it "Tries to delete attachment" do
        sign_in(not_owner)

        expect {
          delete :destroy, id: attachment.id, format: :js
        }.to_not change(question.attachments, :count)
      end
    end

    context "Owner" do
      it "Can delete answer" do
        sign_in(user)

        expect {
          delete :destroy, id: attachment.id, format: :js
        }.to change(question.attachments, :count).by(-1)
      end
    end
  end
end
