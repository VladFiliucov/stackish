shared_examples_for "unauthorized entry" do
  describe 'Non-authenticated user' do
    describe 'POST #create' do
      it 'returns status unauthorized' do
        post :create, entry_params.merge(format: :js)
        expect(response.status).to eq(401)
      end
    end
  end
end
