shared_examples_for "redirects guest to sign up page" do
  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'redirects to sign up page' do
        post :create, entry_params.merge(format: :js)
        expect(response.status).to eq(401)
      end
    end
  end
end
