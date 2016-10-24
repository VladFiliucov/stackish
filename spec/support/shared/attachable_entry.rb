shared_examples_for "attachable entry" do
  describe "DELETE #destroy" do
    let(:attachment) { create(:attachment, attachable: attachable) }

    context "attachable authors attachment" do
      it "deletes" do
        expect { delete :destroy, id: attachment }.to change(attachable.attachments, :count).by(1)
      end
    end
  end
end
