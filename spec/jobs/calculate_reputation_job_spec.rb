require 'rails_helper'

RSpec.describe CalculateReputationJob, type: :job do
  let(:user) { create(:user) }
  let(:object) { create(:question, user: user) }

  it 'calculates and upadtes reputation' do
    expect(Reputation).to receive(:calculate).with(object).and_return(5)
    expect { CalculateReputationJob.perform_now(object) }.to change(user, :reputation).by(5)
  end
end
